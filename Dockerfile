FROM indineroengineering/ruby:2.1.5-bionic

ENV DEBIAN_FRONTEND noninteractive

RUN { \
    echo mysql-community-server mysql-community-server/data-dir select ''; \
    echo mysql-community-server mysql-community-server/root-pass password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    echo mysql-community-server mysql-community-server/remove-test-db select false; \
  } | debconf-set-selections \
  && apt-get update \
  && apt-get install -y cmake libmagic-dev nodejs mongodb openjdk-8-jre-headless mysql-server libmysqlclient-dev redis-server curl xvfb \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
  && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
  && chmod 777 /var/run/mysqld \
  && find /etc/mysql/ -name '*.cnf' -print0 \
    | xargs -0 grep -lZE '^(bind-address|log)' \
    | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
  && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf \
  && curl -o /usr/local/bin/phantomjs https://s3.amazonaws.com/circle-downloads/phantomjs-2.1.1 \
  && chmod 777 /usr/local/bin/phantomjs \
  && gem install bundler -v 1.17.3 \
  # https://alexvanderbist.com/posts/2018/fixing-imagick-error-unauthorized
  && sed -E 's@\s*<policy domain="coder" rights="none" pattern="PDF" />@  <policy domain="coder" rights="read|write" pattern="PDF" />@g' /etc/ImageMagick-6/policy.xml

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["docker-start"]

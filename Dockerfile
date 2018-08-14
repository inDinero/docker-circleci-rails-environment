FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
RUN apt-get update
RUN apt-get install -y --force-yes build-essential cmake pkg-config wget git zlib1g-dev libmagic-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev \
    libxslt-dev ca-certificates nodejs npm default-jre mongodb-org xvfb imagemagick libmagickwand-dev
RUN apt-get clean

RUN { \
    echo mysql-community-server mysql-community-server/data-dir select ''; \
    echo mysql-community-server mysql-community-server/root-pass password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    echo mysql-community-server mysql-community-server/remove-test-db select false; \
  } | debconf-set-selections \
  && apt-get install -y mysql-server libmysqlclient-dev \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
  && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
  && chmod 777 /var/run/mysqld \
  && mysqld --initialize-insecure \
  && service mysql start \
  && mysql -e 'CREATE USER ubuntu@localhost; GRANT ALL PRIVILEGES ON *.* to ubuntu@localhost;FLUSH PRIVILEGES;'

RUN wget -P /root/src http://download.redis.io/releases/redis-4.0.11.tar.gz \
  && cd /root/src \
  && tar xzf redis-4.0.11.tar.gz \
  && cd redis-4.0.11 \
  && make \
  && make install

RUN wget -P /root/src https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz \
  && cd /root/src \
  && tar xvf ruby-2.1.5.tar.gz \
  && cd /root/src/ruby-2.1.5 \
  && ./configure \
  && make \
  && make install \
  && gem install bundler -v '1.14.6'

RUN wget --output-document=/usr/local/bin/phantomjs https://s3.amazonaws.com/circle-downloads/phantomjs-2.1.1 \
  && chmod 777 /usr/local/bin/phantomjs

RUN wget -P /root/src https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
  && cd /root/src \
  && tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
  && cp wkhtmltox/bin/wk* /usr/bin/

WORKDIR /root

RUN rm -rf /root/src/*

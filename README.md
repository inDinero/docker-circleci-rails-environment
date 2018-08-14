# Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)

# Introduction

Dockerfile to build a Rails 3 test environment for CircleCI 2.0 which is the basis for https://hub.docker.com/r/indineroengineering/circleci-rails-environment.

# Installation

### Setup

Build the image from the Dockerfile.

```bash
docker build -t indineroengineering/circleci-rails-environment
```

Run the built image.

```bash
docker run -it -d --privileged=true indineroengineering/circleci-rails-environment "/sbin/init"
```

List the containers

```bash
docker ps
```

Then select the specific container, and access the image.

```bash
docker exec -it container_name bash
```

### Services

Services are pre-installed, but still needs to be started.

#### MySQL

```bash
service mysql restart
```

#### Redis

```bash
redis-server --daemonize yes
```

#### MongoDB

```bash
mkdir -p /root/mongodb/data /root/mongodb/log
/usr/bin/mongod --dbpath /root/mongodb/data --logpath /root/mongodb/log/mongodb.log --logappend --directoryperdb --port 27017 --bind_ip 0.0.0.0 --fork
```

#### Solr

```bash
bundle exec rake sunspot:solr:start
```

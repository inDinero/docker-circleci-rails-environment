# Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)

# Introduction

Dockerfile to build a Rails 3 test environment for CircleCI 2.0 which is the basis for https://hub.docker.com/r/indineroengineering/circleci-rails-environment.

# Installation

### Setup

Build the image from the Dockerfile.

```bash
docker build -t indineroengineering/circleci-rails-environment:0.0.5
```

Run the built image.

```bash
docker run -it indineroengineering/circleci-rails-environment docker-start bash
```

### Services

Services are pre-installed but still need to be started.

Services are automatically started when the `CMD` is prepended with `docker-start`. See the `docker-entrypoint.sh` file for the services that are initialized.

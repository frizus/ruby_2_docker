FROM ubuntu:24.04

# Установка rvm без root прав
# Получить список нужных библиотек для работы rvm, чтобы установить под root'ом перед установкой rvm:
#
# Выполнить:
# docker run --rm -it ubuntu:24.04 bash
#
# В подключенном контейнере запустить:
# apt-get -y update
# apt-get install -y curl
# \curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.10 --autolibs=read-fail
#
# В консоли последним сообщением будет красным:
# Missing required packages: patch (вот patch и дальше это нужные библиотеки)
#
#
# Или
#
# https://stackoverflow.com/a/17219765
# Получить список библиотек нужных для работы rvm:
# rvm autolibs read-fail
# rvm requirements
#
#
# также в список нужно добавить curl git libpq-dev

RUN apt-get -y update && \
    apt-get install -y patch bzip2 gawk g++ gcc autoconf automake bison \
    libc6-dev libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool \
    libyaml-dev make patch pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev \
    curl git libpq-dev

# https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
RUN DEBIAN_FRONTEND=noninteractive TZ=Utc/UTC apt-get -y install tzdata

ARG SITE_EDITOR_GID=830
ARG DOCKER_USER_UID_GID=1100
ARG DOCKER_WEB_USER=810
ARG RUBY_VERSION=2.2.10
ARG NVM_VERSION=v0.39.7
ARG NODEJS_VERSION=20.9.0

RUN groupadd -g $SITE_EDITOR_GID site_editor && \
	useradd -Um -u $DOCKER_USER_UID_GID -G site_editor docker_user && \
	useradd -MrU -u $DOCKER_WEB_USER -G site_editor -d /nonexistent -s /usr/sbin/nologin docker_web_user

USER docker_user


# https://stackoverflow.com/a/42218882
RUN \curl -sSL https://get.rvm.io | bash -s stable --autolibs=disable && \
    \. ~/.zshrc && \
    rvm pkg install openssl && \
    rvm install "ruby-$RUBY_VERSION" --with-openssl-dir=/home/docker_user/.rvm/usr

# https://stackoverflow.com/a/29443824
# ссылка для source'а
RUN echo "\nsource ~/.rvm/scripts/rvm\n" >> ~/.bashrc && \
    echo "\numask 002\n" >> ~/.bashrc && \
    echo "\nsource ~/.rvm/scripts/rvm\n" >> ~/.profile && \
    echo "\numask 002\n" >> ~/.profile && \
    git config --global --add safe.directory "*"

SHELL ["/bin/bash", "-c"]
RUN source ~/.rvm/scripts/rvm && \
    rvm use --default ruby-$RUBY_VERSION
SHELL ["/bin/sh", "-c"]

WORKDIR /home/docker_user

# https://github.com/nvm-sh/nvm
RUN export PROFILE=/dev/null && \
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

RUN export NVM_DIR=/home/docker_user/.nvm && \
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
	nvm install $NODEJS_VERSION && \
	npm install -g yarn

RUN echo "\nexport NVM_DIR=\"/home/docker_user/.nvm\"\n" \
	"[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm\n" \
	"[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion\n" >> ~/.bashrc && \
    echo "\nexport NVM_DIR=\"/home/docker_user/.nvm\"\n" \
    	"[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm\n" \
    	"[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion\n" >> ~/.profile

SHELL ["/bin/bash", "-c"]

RUN source ~/.rvm/scripts/rvm && \
    gem install bundler -v 1.17.3

WORKDIR /home/docker_user/web
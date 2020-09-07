FROM ruby:2.5-stretch

ENV TZ "Europe/Berlin"
ENV LANG "en_US.UTF-8"
ENV MAKEFLAGS "-j$(nproc)"

RUN apt-get update -qq
RUN apt-get dist-upgrade -y

RUN groupadd --gid 1000 web && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash web

RUN apt-get install -y locales-all build-essential

USER web

RUN mkdir /home/web/app
WORKDIR /home/web/app

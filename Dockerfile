FROM ubuntu:14.04
MAINTAINER subicura@subicura.com

# update ubuntu latest
RUN \
  apt-get -qq update && \
  apt-get -qq -y dist-upgrade

RUN \
  apt-get install -y -q software-properties-common wget &&\
  add-apt-repository -y ppa:chris-lea/node.js &&\
  apt-get -y update

# install essential packages
RUN \
  apt-get -qq -y install build-essential software-properties-common python-software-properties git firefox openjdk-7-jre-headless nodejs x11vnc xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

# install ruby2.2
RUN \
  add-apt-repository -y ppa:brightbox/ruby-ng && \
  apt-get -qq update && \
  apt-get -qq -y install ruby2.2 ruby2.2-dev && \
  gem install bundler --no-ri --no-rdoc

# cleanup
RUN apt-get -qq -y clean

# add application
WORKDIR /app

# run bundle
ADD ./Gemfile /app/Gemfile
ADD ./Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test

# add sources
ADD . /app

# set environment variables
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu/
ENV SLACK_TEAM TEAM_NAME
ENV SLACK_ADMIN_EMAIL ADMIN_EMAIL
ENV SLACK_ADMIN_PASSWORD ADMIN_PASSWORD
ENV SLACK_TEAM_DESC TEAM_DESC
ENV SESSION_SECRET_KEY SESSION_SECRET_KEY
ENV REDIS_SERVER 172.17.42.1:6379
ENV REDIS_DB 2
ENV SERVER_PORT 80
ENV SERVER_HOST 0.0.0.0

# run
EXPOSE 80
CMD /app/docker/run.sh

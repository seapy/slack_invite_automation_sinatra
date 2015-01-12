#
# https://github.com/subicura/slack_invite_automation_sinatra
#
# build command
# * docker build --force-rm=true -t subicura/slack_invite .

FROM ubuntu:14.04
MAINTAINER subicura@subicura.com

# update ubuntu latest
RUN \
  apt-get -qq update && \
  apt-get -qq -y dist-upgrade

# install essential packages
RUN \
  apt-get -qq -y install build-essential software-properties-common python-software-properties git

# install ruby2.2
RUN \
  add-apt-repository -y ppa:brightbox/ruby-ng && \
  apt-get -qq update && \
  apt-get -qq -y install ruby2.2 ruby2.2-dev && \
  gem install bundler --no-ri --no-rdoc

# cleanup
RUN apt-get -qq -y clean

# add sources
ADD . /app

# add application
WORKDIR /app

# run bundle
RUN bundle install --without development test

# run
EXPOSE 80
CMD bundle exec ruby server.rb -p 80

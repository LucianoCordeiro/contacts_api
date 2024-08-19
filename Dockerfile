FROM ruby:3.3.4-alpine3.19

RUN apk add --update --no-cache \
  build-base \
  shared-mime-info \
  postgresql-dev \
  tzdata \
  bash

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

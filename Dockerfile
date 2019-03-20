FROM ruby:2.5.3-alpine

# Installation of dependencies
RUN apk update && apk upgrade
RUN apk add --update alpine-sdk postgresql-dev nodejs

# Add Gemfile, install gems and copy over our application code
ENV APP_HOME /secretsanta
ENV SECRET_KEY_BASE mykey
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
# RUN bundle install --without development test
RUN bundle install
ADD . $APP_HOME

# Remove some directories to trim down the size of the image
RUN rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log

# Run our app
CMD bundle exec rake db:create \
  && bundle exec rake db:migrate \
  && bundle exec foreman s

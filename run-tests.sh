#!/bin/sh
bundle exec rake db:test:prepare && bundle exec rspec spec

#!/bin/bash
set -e

# Needed for foreman
gem install bundler

rm -f tmp/pids/server.pid
echo -----------------------------------------------------------------
echo CREATING THE DATABASE
echo -----------------------------------------------------------------
rake db:create && rake db:migrate
echo ABOUT TO START FOREMAN
foreman s

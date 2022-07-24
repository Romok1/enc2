#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

#yarn check || yarn install
#bundle check || bundle install
bundle exec sidekiq

exec "$@" 

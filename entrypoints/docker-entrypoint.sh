#!/bin/sh

set -e

rake db:create
rake db:migrate

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0

#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

/bin/bash -l -c "rm -rf /enc2-changeR/app/public/packs; rm -rf /enc2-changeR/tmp/cache/webpacker" 
 
/bin/bash -l -c ./bin/webpack-dev-server

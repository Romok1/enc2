#!/bin/bash

set -e

if [ -f /enc2/tmp/pids/server.pid ]; then
  rm /enc2/tmp/pids/server.pid
fi


exec "$@"

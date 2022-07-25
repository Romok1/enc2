#!/bin/bash 

set -e

/bin/bash -l -c bundle exec rails comfy:cms_seeds:import[ncfa,ncfa]
/bin/bash -l -c bundle exec rails db:create db:migrate

#exec "$@"

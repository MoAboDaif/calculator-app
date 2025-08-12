#! /bin/bash

export SERVER_NAME=localhost
export FRONTEND_HOST=localhost
export FRONTEND_PORT=3000
export BACKEND_HOST=localhost
export BACKEND_PORT=5000

envsubst  < nginx.conf.template \
          > default.conf

sudo cp default.conf /etc/nginx/conf.d/default.conf
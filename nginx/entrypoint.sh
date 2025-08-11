#! /bin/bash

SERVER_NAME=calculator.ctrlmasters.com
FRONTEND_HOST=localhost
FRONTEND_PORT=3000
BACKEND_HOST=localhost
BACKEND_PORT=5000

envsubst < nginx.conf.template \
                | sudo tee /etc/nginx/conf.d/default.conf
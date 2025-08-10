#!/bin/sh
envsubst '${SERVER_NAME} ${FRONTEND_HOST} ${FRONTEND_PORT} ${BACKEND_HOST} ${BACKEND_PORT}' \
    < /etc/nginx/templates/nginx.conf.template \
    > /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'

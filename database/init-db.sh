#!/bin/bash

export MYSQL_HOST=localhost
export MYSQL_DB=calculator_db
export MYSQL_USER=calculator_user
export MYSQL_PASSWORD=securepassword
export SECRET_KEY=secretkey

envsubst < init.sql.template \
                > init.sql

envsubst < seed.sql.template \
                > seed.sql

sudo mysql -h localhost -u root < init.sql
sudo mysql -h localhost -u root < seed.sql
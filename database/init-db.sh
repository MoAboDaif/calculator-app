#!/bin/bash

envsubst < init.sql.template \
                > init.sql

envsubst < seed.sql.template \
                > seed.sql

sudo mysql -h localhost -u root < init.sql
sudo mysql -h localhost -u root < seed.sql
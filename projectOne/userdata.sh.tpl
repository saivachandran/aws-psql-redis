#!/usr/bin/env bash

set -o xtrace
set -x

sudo apt update 
sudo apt install postgresql-client  -y

PGPASSWORD=${password} psql -h ${host} -U ${username} -d postgresql

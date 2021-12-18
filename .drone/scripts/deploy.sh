#!/usr/bin/env bash
set -ex

apt-get update
apt-get install docker.io -y

find '/var/www/mailcow.hunterwittenborn.com' \
     -maxdepth 1 \
     -not -path '/var/www/mailcow.hunterwittenborn.com' \
     -not -path '/var/www/mailcow.hunterwittenborn.com/service.sh' \
     -exec rm '{}' -rf \;

find ./ \
     -maxdepth 1 \
     -exec cp '{}' '/var/www/mailcow.hunterwittenborn.com/{}' -R \;

cd '/var/www/mailcow.hunterwittenborn.com'

docker-compose down --remove-orphans
docker-compose up -d

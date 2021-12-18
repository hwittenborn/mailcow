#!/usr/bin/env bash
set -ex

apt-get update
apt-get install docker.io -y

deploy_path='/var/www/mailcow.hunterwittenborn.com'

cd "${deploy_path}"
#docker-compose down --remove-orphans
cd -

find "${deploy_path}" \
     -maxdepth 1 \
     -not -path "${deploy_path}" \
     -not -path "${deploy_path}/service.sh" \
     -not -path "${deploy_path}/data" \
     -exec rm '{}' -rfv \;

find "${deploy_path}/data" \
     -maxdepth 1 \
     -not -path "${deploy_path}/data" \
     -noth -path "${deploy_path}/data/user" \
     -exec rm '{}' -rfv \;

find ./ \
     -maxdepth 1 \
     -not -path './' \
     -not -path "./service.sh" \
     -not -path "./data" \
     -exec cp '{}' "${deploy_path}/{}" -Rv \;

find ./data \
     -maxdepth 1 \
     -not -path "./data" \
     -noth -path "./data/user" \
     -exec cp '{}' "${deploy_path}/{}" -Rv \;

cp /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem "${deploy_path}/data/assets/ssl/cert.pem"
cp /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem "${deploy_path}/data/assets/ssl/key.pem"

cd "${deploy_path}"
docker-compose up -d

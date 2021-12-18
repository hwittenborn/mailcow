#!/usr/bin/env bash
set -ex

apt-get update
apt-get install docker.io -y

deploy_path='/var/www/mailcow.hunterwittenborn.com'

cd "${deploy_path}"
docker-compose down --remove-orphans
cd -

find "${deploy_path}" \
     -maxdepth 1 \
     -not -path "${deploy_path}" \
     -not -path "${deploy_path}/service.sh" \
     -exec rm '{}' -rf \;

find ./ \
     -maxdepth 1 \
     -not -path './' \
     -not -path "${deploy_path}/service.sh" \
     -exec cp '{}' "${deploy_path}/{}" -R \;

cp /etc/letsencrypt/live/hunterwittenborn.com/fullchain.pem "${deploy_path}/data/assets/ssl/cert.pem"
cp /etc/letsencrypt/live/hunterwittenborn.com/privkey.pem "${deploy_path}/data/assets/ssl/key.pem"

cd "${deploy_path}"
docker-compose up -d

#!/usr/bin/env bash
set -ex

deploy_path='/var/www/mailcow.hunterwittenborn.com'

cd "${deploy_path}"
docker-compose down --remove-orphans
cd -

find "${deploy_path}" \
    -mindepth 1 \
    -maxdepth 1 \
    -exec rm '{}' -rfv \;

find ./ \
    -mindepth 1 \
    -maxdepth 1 \
    -exec cp '{}' "${deploy_path}/{}" -Rv \;

cp /etc/letsencrypt/live/homelab/fullchain.pem "${deploy_path}/data/assets/ssl/cert.pem"
cp /etc/letsencrypt/live/homelab/privkey.pem "${deploy_path}/data/assets/ssl/key.pem"

cd "${deploy_path}"
docker-compose up -d

# vim: set sw=4 expandtab

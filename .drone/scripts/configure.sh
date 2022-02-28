#!/usr/bin/env bash
set -ex

apt-get update
apt-get install curl sed openssl docker-compose docker git gawk -y

export MAILCOW_HOSTNAME="mailcow.${hw_url}"
export MAILCOW_TZ="$(cat /etc/timezone)"
./generate_config.sh

sed -i "s|^DBPASS=.*|DBPASS=${mailcow_db_user_password}|" mailcow.conf
sed -i "s|^DBROOT=.*|DBROOT=${mailcow_db_root_password}|" mailcow.conf
sed -i "s|^SQL_PORT=.*|SQL_PORT=5072|" mailcow.conf
sed -i "s|^HTTP_PORT=.*|HTTP_PORT=5070|" mailcow.conf
sed -i "s|^HTTPS_PORT=.*|HTTPS_PORT=5071|" mailcow.conf
sed -i 's|^HTTP_BIND=.*|HTTP_BIND=127.0.0.1|' mailcow.conf
sed -i 's|^HTTPS_BIND=.*|HTTPS_BIND=127.0.0.1|' mailcow.conf
sed -i "s|^ADDITIONAL_SAN=.*|ADDITIONAL_SAN=imap.${hw_url},smtp.${hw_url}|" mailcow.conf
sed -i "s|^SKIP_LETS_ENCRYPT=.*|SKIP_LETS_ENCRYPT=y|" mailcow.conf

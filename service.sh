#!/usr/bin/bash
# Script managed by my fork to work with my server setup.
set -e

cd "$(dirname "${0}")"

case "${1}" in
    start)
        docker-compose up -d
        ;;
    stop)
        docker-compose down
        ;;
    backup-prepare)
        docker-compose up -d
        yes | BACKUP_LOCATION="${PWD}/backups" helper-scripts/backup_and_restore.sh backup all --delete-days 1
        docker-compose down
        ;;
    update)
        docker-compose pull
        ;;
esac

# vim: expandtab sw=4

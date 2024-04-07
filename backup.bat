@echo off

cd %~dp0

docker-compose run --rm backup_update bash /app/scripts/backup.sh

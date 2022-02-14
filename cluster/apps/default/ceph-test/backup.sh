#!/usr/bin/env bash

CURRENT_DATE=$(date +"%FT%H%M")

echo "running: mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS --quote-names --databases $DB_DATABASE \>/backup/${DB_DATABASE}.${CURRENT_DATE}.sql"
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS --quote-names --databases $DB_DATABASE >/backup/${DB_DATABASE}.${CURRENT_DATE}.sql

echo "Complete."
/bin/ls -l /backup

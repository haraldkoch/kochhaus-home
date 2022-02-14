#!/usr/bin/env bash

CURRENT_DATE=$(date +"%FT%H%M")

mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS --quote-names --databases $DB_DATABASE >/backup/${DB_DATABASE}.${CURRENT_DATE}.sql

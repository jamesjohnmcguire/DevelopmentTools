#!/bin/bash

if [ "$1" == "data" ]; then
	mysqldump --default-character-set=utf8mb4 --no-tablespaces --single-transaction --skip-dump-date --no-create-info --extended-insert -h localhost -u %3 --password=%4 %2 >%5.sql
fi

if [ "$1" == "fast" ]; then
	mysqldump --default-character-set=utf8mb4 --no-tablespaces --single-transaction --skip-comments --skip-dump-date --extended-insert -h localhost -u %3 --password=%4 %2 >%5.sql
fi

if [ "$1" == "full" ]; then
	mysqldump --default-character-set=utf8mb4 --no-tablespaces --single-transaction --skip-dump-date --complete-insert --extended-insert=FALSE -h localhost -u %3 --password=%4 %2 >%5.sql
fi

if [ "$1" == "schema" ]; then
	mysqldump --default-character-set=utf8mb4 --no-tablespaces --skip-dump-date -d -h localhost -u %3 --password=%4 -d %2 >%5.sql
fi

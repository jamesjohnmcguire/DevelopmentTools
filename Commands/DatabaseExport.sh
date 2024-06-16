#!/bin/bash

if [ "$1" == "data" ]; then
	mysqldump --skip-dump-date --no-create-info --extended-insert -h localhost -u %3 --password=%4 %2 >%5.sql
fi

if [ "$1" == "fast" ]; then
	mysqldump --skip-dump-date --extended-insert -h localhost -u %3 --password=%4 %2 >%5.sql
fi

if [ "$1" == "full" ]; then
	mysqldump --skip-dump-date --complete-insert --extended-insert=FALSE -h localhost -u %3 --password=%4 %2 >%5.sql
fi

if [ "$1" == "schema" ]; then
	mysqldump --skip-dump-date -d -h localhost -u %3 --password=%4 -d %2 >%5.sql
fi

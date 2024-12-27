@IF "%1"=="data" GOTO data
@IF "%1"=="fast" GOTO fast
@IF "%1"=="full" GOTO full
@IF "%1"=="schema" GOTO schema
@GOTO end

:data
	mysqldump --skip-dump-date --no-create-info --extended-insert -h localhost -u %3 --password=%4 %2 >%5.sql
@GOTO end

:fast
	mysqldump --skip-dump-date --opt -h localhost -u %3 --password=%4 %2 >%5.sql
@GOTO end

:full
	mysqldump --skip-dump-date --complete-insert --extended-insert=FALSE -h localhost -u %3 --password=%4 %2 >%5.sql
@GOTO end

:schema
	mysqldump --default-character-set=utf8mb4 --no-data --single-transaction --skip-dump-date -h localhost -u %3 --password=%4 %2 >%5.sql
@GOTO end

:end
SED -i "s| AUTO_INCREMENT=[0-9]*||g" %5.sql

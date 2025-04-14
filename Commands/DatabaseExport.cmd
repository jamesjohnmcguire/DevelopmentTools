@IF "%1"=="data" GOTO data
@IF "%1"=="fast" GOTO fast
@IF "%1"=="full" GOTO full
@IF "%1"=="schema" GOTO schema
@GOTO end

:data
mysqldump --default-character-set=utf8mb4 --skip-dump-date -h localhost -u %3 --password=%4 --no-create-info --extended-insert %2 >%5.sql
@GOTO end

:fast
mysqldump --default-character-set=utf8mb4 --skip-dump-date -h localhost -u %3 --password=%4 --opt %2 >%5.sql
@GOTO end

:full
mysqldump --default-character-set=utf8mb4 --skip-dump-date -h localhost -u %3 --password=%4 --complete-insert --extended-insert=FALSE %2 >%5.sql
@GOTO end

:schema
mysqldump --default-character-set=utf8mb4 --skip-dump-date -h localhost -u %3 --password=%4 --no-data --single-transaction %2 >%5.sql
@GOTO end

:end
SED -i "s| AUTO_INCREMENT=[0-9]*||g" %5.sql

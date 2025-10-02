@ECHO OFF
SETLOCAL

IF "%~1"=="" ECHO Usage: mySqlClean.cmd sql_file.sql
IF "%~1"=="" EXIT /B 1

IF NOT EXIST "%~1" ECHO Error: File "%~1" not found
IF NOT EXIST "%~1" EXIT /B 1

sed -i "1i SET NAMES utf8mb4;" %1
sed -i "2i SET CHARACTER_SET_CLIENT = utf8mb4;" %1
sed -i "3i SET CHARACTER_SET_CONNECTION = utf8mb4;" %1

sed -i "s|bigint(20)|bigint|g" %1
sed -i "s|int(11)|int|g" %1
sed -i "s|smallint([0-9]*)|smallint|g" %1
sed -i "s|tinyint([0-9]*)|tinyint|g" %1

sed -i "s|datetime DEFAULT '0000-00-00 00:00:00'|datetime DEFAULT NULL|g" %1
sed -i "s|NOT NULL DEFAULT '0000-00-00 00:00:00'|DEFAULT NULL|g" %1
sed -i "s|'0000-00-00 00:00:00'|NULL|g" %1
sed -i "s|longtext NOT NULL,|longtext NOT NULL DEFAULT '',|g" %1

sed -i "s|DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci|DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci|g" %1
sed -i "s|CHARSET=latin1|CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci|g" %1
sed -i "s|CHARACTER SET latin1|CHARACTER SET utf8mb4|g" %1

:end
ENDLOCAL

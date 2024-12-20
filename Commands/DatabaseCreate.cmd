@echo off
REM MySqlRoot and MySqlPassword must be set as environment variables

SETLOCAL

SET DatabaseName=%1
SET DatabaseUser=%2
SET DatabasePassword=%3

mysql -u %MySqlRoot% --password=%MySqlPassword% -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '%DatabaseName%';" > db_check_result.txt

FINDSTR /I /C:"%DatabaseName%" db_check_result.txt > nul
IF %errorlevel% EQU 1 (
	@ECHO ON
	mysql --default-character-set=utf8 --show-warnings -u %MySqlRoot% --password=%MySqlPassword% -e "CREATE DATABASE `%DatabaseName%`"
	mysql --default-character-set=utf8 --show-warnings -u %MySqlRoot% --password=%MySqlPassword% -e "use `%DatabaseName%`; GRANT ALL PRIVILEGES ON `%DatabaseName%`.* to `%DatabaseUser%`@localhost IDENTIFIED BY '%DatabasePassword%'"
)

@ECHO OFF
DEL db_check_result.txt

@ECHO OFF
SETLOCAL

CALL remoteBaseOptions.cmd %*

SET type=%1
SET remoteServer=%2
SET remoteUser=%3
SET remoteAuthentication=%4 %5
SET databaseCredientials=-u %6 --password='%7'
SET host=-h %8
SET database=%9

SHIFT
SET remotePath=%9

IF %verbose%==true GOTO verbose
GOTO continue

:verbose
ECHO Verbose Is: ON
ECHO Type Is: %type%
ECHO Database Credentials Are: %databaseCredientials%
ECHO Database Host Is: %host%
ECHO Database Is: %database%

:continue
IF "%type%"=="data" GOTO data
IF "%type%"=="fast" GOTO fast
IF "%type%"=="full" GOTO full
IF "%type%"=="schema" GOTO schema
GOTO end

:data
SET databaseOptions=--no-create-info --extended-insert
GOTO run

:fast
SET databaseOptions=--opt
GOTO run

:full
SET databaseOptions=--complete-insert --extended-insert=FALSE
GOTO run

:schema
SET databaseOptions=-d
GOTO run

:run
SET remoteCommand="cd %remotePath%; mysqldump --skip-dump-date --no-tablespaces %databaseOptions% %host% %databaseCredientials% %database% > %database%.%type%.sql"

CALL remote.cmd command %remoteServer% %remoteUser% %remoteAuthentication% %remoteCommand% %verbose%

CALL remote.cmd get %remoteServer% %remoteUser% %remoteAuthentication% %remotePath% %database%.%type%.sql

:end
ENDLOCAL

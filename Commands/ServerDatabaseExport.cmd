@ECHO OFF
SETLOCAL

SET Verbose=false

FOR %%i IN (%*) DO (
	IF /i "%%i"=="verbose" SET Verbose=true
)

IF %Verbose%==true SET @ECHO ON

SET SERVERUSER=%3@%2
SET AUTHENTICATION=%4 %5
SET PORT=%6
SET MySqlCredientials=-u %7 --password='%8'
SET Database=%9
SET Type=%1
@IF "%1"=="data" GOTO data
@IF "%1"=="fast" GOTO fast
@IF "%1"=="full" GOTO full
@IF "%1"=="schema" GOTO schema
@GOTO end

:data
	SET MySqlOptions=--no-create-info --extended-insert
@GOTO end

:fast
	SET MySqlOptions=--opt
@GOTO end

:full
	SET MySqlOptions=--complete-insert --extended-insert=FALSE
@GOTO end

:schema
	SET MySqlOptions=-d
@GOTO end

:end

SHIFT
SET remotePath=%9
SHIFT
IF NOT [%9]==[] SET DatabaseHost=-h %~9

IF %Verbose%==true GOTO information
GOTO run

:information
ECHO ServerUser %SERVERUSER%
ECHO Auth %AUTHENTICATION%
ECHO MySqlOptions %MySqlOptions%
ECHO MySqlCredientials %MySqlCredientials%
ECHO Database %Database%
ECHO remotePath %remotePath%
ECHO DatabaseHost %DatabaseHost%

:run
CALL server.cmd %SERVERUSER% %AUTHENTICATION% %PORT% "cd %remotePath%; mysqldump --skip-dump-date --no-tablespaces %MySqlOptions% %DatabaseHost% %MySqlCredientials% %Database% > %Database%.%Type%.sql"

pscp -P %PORT% %AUTHENTICATION% %SERVERUSER%:%remotePath%/%Database%.%Type%.sql %Database%.%Type%.sql

ENDLOCAL

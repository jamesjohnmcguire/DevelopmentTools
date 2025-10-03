@ECHO OFF
SETLOCAL

CALL remoteTests.cmd

CD %~dp0
CD ..\Commands

:mysql-clean
ECHO Testing MySql Clean Up...
CD TestData
COPY /Y mysql-old-original.sql mysql-old-test.sql

CALL mySqlClean.cmd mysql-old-test.sql

SET checkCode=%ERRORLEVEL%
DEL /Q mysql-old-test.sql
CD ..
ECHO .

if %checkCode% NEQ 0 ECHO mySqlClean.cmd Check Failed
if %checkCode% EQU 0 ECHO [96mmySqlClean.cmd Check Succeeded[0m

:end
ENDLOCAL

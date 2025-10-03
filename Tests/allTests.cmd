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
DEL /Q mysql-old-test.sql
CD ..
ECHO .

:end
ENDLOCAL

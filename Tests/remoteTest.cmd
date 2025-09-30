@ECHO OFF
SETLOCAL

CD %~dp0
CD ..\Commands

SET testServer=%EuroCasaServer%
SET testUser=%EuroCasaUserId%
SET testRemotePath=/home/%EuroCasaUserId%
SET testAuthentication=-pw %EuroCasaPassword%

:get-file
ECHO Getting file...
CALL remote.cmd get %testServer% %testUser% %testAuthentication% %testRemotePath% .bash_history verbose
DEL /Q .bash_history
ECHO .

:get-directory
ECHO Getting directory...
CALL remote.cmd get %testServer% %testUser% %testAuthentication% %testRemotePath% bin verbose recurse
RD /S /Q bin
ECHO .

:get-database
ECHO Getting database dump...
CALL ServerDatabaseExport.cmd full %testServer% %testUser% %testAuthentication% %testUser% %EuroCasaDbPassword% %EuroCasaDbHost% %testUser%_main /home/%testUser% verbose
DEL /Q %testUser%_main.full.sql
ECHO .

ECHO Putting file...
CALL remote.cmd put %testServer% %testUser% %testAuthentication% %testRemotePath% test.sql verbose
ECHO .

ECHO Putting directory...
CALL remote.cmd put %testServer% %testUser% %testAuthentication% %testRemotePath% TestData verbose recurse
ECHO .

:end
ENDLOCAL

@ECHO OFF
SETLOCAL

SET SERVERUSER=%2@%1
SET AUTHENTICATION=%3 %4
SET PORT=%5
SET MySqlCredientials=--user=%6 --password='%7'
SET SqlFile=%8
SET remotePath=%9

SHIFT
IF NOT [%9]==[] SET DatabaseHost=-h %~9

ECHO ServerUser %SERVERUSER%
ECHO Auth %AUTHENTICATION%
ECHO MySqlCredientials %MySqlCredientials%
ECHO SqlFile %SqlFile%
ECHO DatabaseHost %DatabaseHost%

CALL server.cmd %SERVERUSER% %AUTHENTICATION% %PORT% "cd %remotePath%; mysql --default-character-set=utf8mb4 --show-warnings --verbose %DatabaseHost% %MySqlCredientials% %Database% < %SqlFile%"

ENDLOCAL
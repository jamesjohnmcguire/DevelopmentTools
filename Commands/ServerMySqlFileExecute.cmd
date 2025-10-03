@ECHO OFF
SETLOCAL

SET server=%1
SET user=%2
SET authentication=%3 %4
SET databaseHost=-h %5
SET databaseCredientials=--user=%6 --password='%7'
SET database=%8
SET remotePath=%9

SHIFT
SET sqlFile=%9

ECHO databaseHost %databaseHost%
ECHO MySqlCredientials %mySqlCredientials%
ECHO SqlFile %sqlFile%

CALL remote.cmd put %server% %user% %authentication% %remotePath% %sqlFile%

SET remoteCommand="cd %remotePath%; mysql --default-character-set=utf8mb4 --show-warnings --verbose %databaseHost% %databaseCredientials% %database% < %sqlFile%"

CALL remote.cmd command %server% %user% %authentication% %remoteCommand% %verbose%

ENDLOCAL

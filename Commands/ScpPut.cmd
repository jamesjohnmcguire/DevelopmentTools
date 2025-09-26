@ECHO OFF
SETLOCAL
@if [%6]==[] GOTO usage

SET server=%1
SET user=%2
SET authentication=%3 %4
SET remotePath=%5
SET scpFile=%6

IF NOT [%7]==[] SET option1=%7
IF NOT [%8]==[] SET option2=%8

CALL remote.cmd put %server% %user% %authentication% %remotePath% %scpFile% %option1% %option2%
GOTO end

:usage
ECHO "ERROR usage: ScpPut [server] [user] [authenication option] [authenication data] [remote path] [file(s)] <[options]>"

:end
ENDLOCAL

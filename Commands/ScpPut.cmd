@ECHO OFF
@if [%6]==[] GOTO usage

SET Server=%1
SET User=%2
SET Authentication=%3 %4
SET RemotePath=%5
SET File=%6

if [%7]==[] GOTO continue
SET Options=%7
SET Options=%Options:"=%

:continue
pscp %Authentication% %Options% %File% %User%@%Server%:%RemotePath%
GOTO finish

:usage
ECHO "ERROR usage: ScpPut [server] [user] [authenication option] [authenication data] [remote path] [file(s)] <[options]>"

:finish

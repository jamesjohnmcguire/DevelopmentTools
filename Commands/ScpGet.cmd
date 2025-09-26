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

CALL remote.cmd get %server% %user% %authentication% %remotePath% %file% %option1% %option2%

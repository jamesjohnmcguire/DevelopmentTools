@ECHO OFF
SETLOCAL

SET "scriptDirectory=%~dp0"

php "%scriptDirectory%\composer.phar" %*

ENDLOCAL

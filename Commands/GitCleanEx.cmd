@ECHO OFF
SETLOCAL

git clean -dffx %1

git submodule foreach --recursive "git clean -dffx %1"

ENDLOCAL

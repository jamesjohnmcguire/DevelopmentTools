@ECHO OFF

pwsh -ExecutionPolicy Bypass -File "%~dp0EmptyDirectoriesRemove.ps1" %*

ECHO.
ECHO Empty directories have been removed.

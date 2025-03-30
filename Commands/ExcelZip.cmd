@echo off
SETLOCAL EnableDelayedExpansion

:: Check if directory is provided
IF "%~1"=="" SET ErrorMessage="Usage: %0 folder_name"
IF "%~1"=="" GOTO error

SET "ContentsDirectory=%~1"
SET "OutputFile=%~n1"

:: Check if directory exists
IF NOT EXIST "%ContentsDirectory%" SET ErrorMessage="Error: Directory %ContentsDirectory% not found"
IF NOT EXIST "%ContentsDirectory%"  GOTO error

:: Rebuild the Excel file
powershell -command Compress-Archive -Force -Path "%ContentsDirectory%\*" -DestinationPath "%OutputFile%".zip
MOVE /Y "%OutputFile%".zip "%OutputFile%"

IF %ERRORLEVEL% neq 0 SET ErrorMessage="Error during rebuilding"
IF %ERRORLEVEL% neq 0 GOTO error

IF "%~2"=="clean" GOTO clean
GOTO success

:clean
RD /S /Q "%ContentsDirectory%"

:success
ECHO Successfully rebuilt %outputFile%
GOTO end

:error
SET LocalErrorLevel=1
ECHO %ErrorMessage%

:end
EXIT /b %LocalErrorLevel%

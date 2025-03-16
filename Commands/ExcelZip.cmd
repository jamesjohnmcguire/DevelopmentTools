@echo off
SETLOCAL EnableDelayedExpansion

:: Check if directory is provided
if "%~1"=="" SET ErrorMessage="Usage: %0 folder_name"
if "%~1"=="" GOTO error

SET "contentsDir=%~1"
SET "outputFile=%~n1_rebuilt.xlsx"

:: Check if directory exists
if not exist "%contentsDir%" SET ErrorMessage="Error: Directory %contentsDir% not found"
if not exist "%contentsDir%"  GOTO error

:: Remove Existing Excel File


:: Rebuild the Excel file
CD "%contentsDir%"
7z a -tzip "..\%outputFile%" *
CD ..

IF %ERRORLEVEL% neq 0 SET ErrorMessage="Error during rebuilding"
IF %ERRORLEVEL% neq 0 GOTO error

:success
ECHO Successfully rebuilt %outputFile%
GOTO end

:error
SET LocalErrorLevel=1
ECHO %ErrorMessage%

:end
EXIT /b %LocalErrorLevel%

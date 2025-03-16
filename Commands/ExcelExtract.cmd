@echo off
SETLOCAL EnableDelayedExpansion

:: TODO - Check for environment variable override
SET CompressionCommand=7z x

SET ExcelFile=%1
SET ExtractDirecory=%1.Contents

:: Create or clear extraction directory
IF EXIST "%ExtractDirecory%" RD /s /q "%ExtractDirecory%"
MD "%ExtractDirecory%"

:: Extract the xlsx file
ECHO Extracting %ExcelFile% to %ExtractDirecory%...
PAUSE
%CompressionCommand% "%ExcelFile%" -o"%ExtractDirecory%" -y >nul

IF %ERRORLEVEL% neq 0 SET ErrorMessage="Failed to extract %ExcelFile%"
IF %ERRORLEVEL% neq 0 GOTO error

:success
ECHO Extraction complete!
GOTO end

:error
SET LocalErrorLevel=1
ECHO ERROR: %ErrorMessage%

:end
EXIT /b %LocalErrorLevel%

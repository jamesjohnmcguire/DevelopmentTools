@echo off
SETLOCAL EnableDelayedExpansion

SET ExcelFile=%1
SET ExtractDirecory=%1.contents

:: Create or clear extraction directory
IF EXIST "%ExtractDirecory%" RD /s /q "%ExtractDirecory%"
MD "%ExtractDirecory%"

:: Extract the xlsx file
ECHO Extracting %ExcelFile% to %ExtractDirecory%...
COPY /Y "%ExcelFile%" "%ExcelFile%".zip
powershell -command Expand-Archive -Force -Path "%ExcelFile%.zip" -DestinationPath "%ExtractDirecory%"

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

@ECHO OFF
SETLOCAL enabledelayedexpansion

SET LocalErrorLevel=0

:: Check if Guetzli is available
WHERE guetzli >nul 2>nul
IF %errorlevel% neq 0 SET ErrorMessage="Guetzli not found. Please install and add it to your PATH."
IF %errorlevel% neq 0 GOTO error

:: Default directory is current directory unless specified
SET "TargetDirectory=%CD%"
if not "%~1"=="" SET "TargetDirectory=%~1"

:: Check if backup is requested
SET "BackUpMode=0"
IF /I "%~2"=="backup" SET "BackUpMode=1"
IF /I "%~2"=="backup" MKDIR "%TargetDirectory%\BackUps" 2>nul

ECHO Processing JPEG files in %TargetDirectory%...
FOR /r "%TargetDirectory%" %%F in (*.jpg *.jpeg) do (
	SET "FILE=%%F"
	CALL ImageOptimize !FILE! %2
)

:success
ECHO Optimization complete!
GOTO end

:error
SET LocalErrorLevel=1
ECHO ERROR: %ErrorMessage%

:end
exit /b %LocalErrorLevel%

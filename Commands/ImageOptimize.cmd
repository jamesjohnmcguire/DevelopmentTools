@ECHO OFF
SETLOCAL enabledelayedexpansion

SET LocalErrorLevel=0

:: Check if a file was passed
IF "%~1"=="" SET ErrorMessage=Usage: %~nx0 ^<image^> [backup]
IF "%~1"=="" GOTO error


SET "FILE=%~1"
SET "BackUpMode=0"
IF /I "%~2"=="backup" SET "BackUpMode=1"

:: Check if Guetzli is available
WHERE guetzli >nul 2>nul
IF %errorlevel% neq 0 SET ErrorMessage="Guetzli not found. Please install and add it to your PATH."
IF %errorlevel% neq 0 GOTO error

IF NOT EXIST "%FILE%" SET ErrorMessage="Input file not found: %FILE%"
IF NOT EXIST "%FILE%" GOTO error

IF !BackUpMode! == 1 GOTO backup
GOTO optimize

:backup
SET "BackupDir=%~dp1BackUps"
MD "!BackupDir!" 2>nul
COPY /Y "%FILE%" "!BackupDir!\" >nul
ECHO Backed up "%FILE%" to "!BackupDir!"

:optimize
ECHO Optimizing: "%FILE%"
guetzli --quality 85 "%FILE%" "%FILE%.new"

IF NOT EXIST "%FILE%.new" SET ErrorMessage=WARNING: Guetzli failed on "%FILE%"
IF NOT EXIST "%FILE%.new" GOTO error

:overwrite
MOVE /Y "%FILE%.new" "%FILE%" >nul
ECHO Optimization complete!
GOTO end

:error
SET LocalErrorLevel=1
ECHO ERROR: %ErrorMessage%

:end
EXIT /B %LocalErrorLevel%

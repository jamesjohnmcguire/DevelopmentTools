@ECHO OFF
SETLOCAL enabledelayedexpansion

SET LocalErrorLevel=0

:: Check if a file was passed
IF "%~1"=="" SET ErrorMessage=Usage: %~nx0 ^<video^> [backup]
IF "%~1"=="" GOTO error


SET "FILE=%~1"
SET "BackUpMode=0"
IF /I "%~2"=="backup" SET "BackUpMode=1"

:: Check if ffmpeg is available
WHERE ffmpeg >nul 2>nul
IF %errorlevel% neq 0 SET ErrorMessage="Ffmpeg not found. Please install and add it to your PATH."
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
set "FileName=%~n1"
set "NewFileName=%FileName%.mp4"

ECHO Optimizing: "%FILE%"
ffmpeg -i "%FILE%" -vcodec libx264 -crf 23 -preset slow -acodec aac -movflags +faststart output.mp4

IF NOT EXIST output.mp4 SET ErrorMessage=WARNING: Ffmpeg failed on "%FILE%"
IF NOT EXIST output.mp4 GOTO error

:overwrite
DEL /Q "%FILE%"
MOVE /Y output.mp4 "%NewFileName%" >nul
ECHO Optimization complete!
GOTO end

:error
SET LocalErrorLevel=1
ECHO ERROR: %ErrorMessage%

:end
EXIT /B %LocalErrorLevel%

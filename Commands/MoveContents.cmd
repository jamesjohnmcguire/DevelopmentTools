@ECHO off

IF "%~1"=="" SET ErrorMessage="Source directory not specified."
IF "%~1"=="" GOTO error

IF "%~2"=="" SET ErrorMessage="Target directory not specified."
IF "%~2"=="" GOTO error

SET "source=%~1"
SET "target=%~2"

IF NOT EXIST "%source%" SET ErrorMessage="Source directory "%source%" does not exist."
IF NOT EXIST "%source%" GOTO error

IF NOT EXIST "%target%" ECHO Target directory "%target%" does not exist. Creating it...
IF NOT EXIST "%target%" MD "%target%"
IF %ERRORLEVEL% NEQ 0 SET ErrorMessage="Failed to create target directory "%target%"."
IF %ERRORLEVEL% NEQ 0 GOTO error

DIR /a-d "%source%\*" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 ECHO No files to move in "%source%".
IF %ERRORLEVEL% NEQ 0 GOTO sub-directories

ECHO Moving files from "%source%" to "%target%"...
MOVE /y "%source%\*" "%target%\"
IF %ERRORLEVEL% NEQ 0 ECHO Error: Failed to move files.
IF %ERRORLEVEL% EQU 0 ECHO Files moved successfully.

:sub-directories
FOR /d %%d in ("%source%\*") DO (
	SET "subdir_name=%%~nxd"
	IF EXIST "%target%\%%~nxd" (
		ECHO Subdirectory "%%~nxd" already exists in the target. Moving contents...
		MOVE /y "%%d\*" "%target%\%%~nxd\"
		IF errorlevel 1 (
			ECHO Error: Failed to move contents of "%%~nxd".
		) ELSE (
			ECHO Contents of "%%~nxd" moved successfully.
		)
	) ELSE (
		ECHO Moving subdirectory "%%~nxd" to "%target%\"...
		MOVE /y "%%d" "%target%\"
		IF errorlevel 1 (
			ECHO Error: Failed to move subdirectory "%%~nxd".
		) ELSE (
			ECHO Subdirectory "%%~nxd" moved successfully.
		)
	)
)

REM Final check
IF NOT EXIST "%source%\*" (
    ECHO Move operation completed successfully.
) ELSE (
    ECHO Warning: Some files or directories could not be moved.
)


EXIT /b 0

:error
SET ErrorMessage=%ErrorMessage:"=%
ECHO Error: %ErrorMessage%
ECHO Usage: MoveContents.cmd ^<source_directory^> ^<target_directory^>
EXIT /b 1

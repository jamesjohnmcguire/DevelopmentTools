@ECHO off

REM Check if two arguments are provided
IF "%~1"=="" (
	ECHO Error: Source directory not specified.
	ECHO Usage: MoveContents.cmd ^<source_directory^> ^<target_directory^>
	EXIT /b 1
)

IF "%~2"=="" (
	ECHO Error: Target directory not specified.
	ECHO Usage: MoveContents.cmd ^<source_directory^> ^<target_directory^>
	EXIT /b 1
)

SET "source=%~1"
SET "target=%~2"

IF NOT EXIST "%source%" (
	ECHO Error: Source directory "%source%" does not exist.
	EXIT /b 1
)

REM Ensure target directory exists, create it if not
IF NOT EXIST "%target%" (
	ECHO Target directory "%target%" does not exist. Creating it...
	MKDIR "%target%"
	if errorlevel 1 (
		ECHO Error: Failed to create target directory "%target%".
		EXIT /b 1
	)
)


REM Check for files in the source directory
DIR /a-d "%source%\*" >nul 2>&1
IF errorlevel 1 (
	ECHO No files to move in "%source%".
) ELSE (
	ECHO Moving files from "%source%" to "%target%"...
	MOVE /y "%source%\*" "%target%\"
	if errorlevel 1 (
		ECHO Error: Failed to move files.
	) else (
		ECHO Files moved successfully.
	)
)

REM Move subdirectories from source to target
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

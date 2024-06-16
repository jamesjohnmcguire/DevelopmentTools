REM for each file of type (%1), rename to new file type %2
REM Example: RenameFilesInDirectory *.* 640_%%F
REM Note the usage of %%F for the original file name

FOR /f "delims=" %%F IN ('DIR /a-d /b %1')  DO (RENAME "%%F" "%2")

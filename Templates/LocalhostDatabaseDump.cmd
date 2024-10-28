CD %~dp0
CD ..\SourceCode\Database

CALL DatabaseExport.cmd fast dbname user password dbname.localhost.fast
CALL DatabaseExport.cmd full dbname user password dbname.localhost
GOTO finish

:finish

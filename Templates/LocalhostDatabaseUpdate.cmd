CD %~dp0
CD ..\SourceCode\Database

CALL DatabaseImport dbname user password dbname.production.sql

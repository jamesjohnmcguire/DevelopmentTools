REM Project Types: Client, SubClient, Project
REM Project SubTypes: Codeigniter, Development, Web, WordPress

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

C:
CD %~dp0
CD ..\Templates
FOR /F %%i IN ('PWD') DO SET ScriptsTemplates=%%i

SET ProjectType=%1
SET SubType=%2
SET ProjectName=%3
ECHO ProjectName: %ProjectName%

REM Set the lower case project name
SET Text=%3
SET LowerCases=a b c d e f g h i j k l m n o p q r s t u v w x y z
FOR %%Z IN (%LowerCases%) DO SET Text=!Text:%%Z=%%Z!
SET ProjectNameLowerCase=%Text%

SET Exposure=private

SHIFT & SHIFT & SHIFT

:loop
IF NOT "%1"=="" (
	IF "%1"=="-code" (
		SET ProjectCode=%2
		SHIFT
	) ELSE IF "%1"=="-client" (
		SET ClientName=%2
		SHIFT
	) ELSE IF "%1"=="-subproject" (
		SET SubProject=%2
		SHIFT
	) ELSE IF "%1"=="-dbname" (
		SET dbname=%2
		SHIFT
	) ELSE IF "%1"=="-user" (
		SET user=%2
		SHIFT
	) ELSE IF "%1"=="-password" (
		SET password=%2
		SHIFT
	) ELSE IF "%1"=="-email" (
		SET email=%2
		SHIFT
	) ELSE IF "%1"=="-author" (
		SET author=%2
		SHIFT
	) ELSE IF "%1"=="-public" (
		SET Exposure=public
		SHIFT
	)
	SHIFT
	GOTO :loop
)

SET Title=%ProjectName%
IF NOT [%SubProject%]==[] SET Title=%SubProject%

@ECHO Creating %ProjectName% %ProjectType% %SubType% type project for %ClientName%

REM Project Types: Client, SubClient, Project
IF "%ProjectType%"=="client" GOTO client
IF "%ProjectType%"=="Client" GOTO client
IF "%ProjectType%"=="project" GOTO project
IF "%ProjectType%"=="Project" GOTO project
IF "%ProjectType%"=="subclient" GOTO subclient
IF "%ProjectType%"=="SubClient" GOTO subclient

:client
GOTO end

:project
GOTO end

:subproject
if not exist %SubProject%\NUL md %SubProject%
cd %SubProject%
SET ProjectDirectory=%USERPROFILE%\Data\%TYPE%\%ProjectName%\%SubProject%
GOTO end

:subclient
IF [%ClientName%]==[] GOTO clients_error
CD %USERPROFILE%\Data\Clients
IF NOT EXIST %ClientName%\NUL MD %ClientName%
CD %ClientName%
SET ProjectDirectory=%USERPROFILE%\Data\Clients\%ProjectName%
GOTO projects

:clients_error
ECHO ERROR: Client name not defined by -client
GOTO end

:projects
IF NOT EXIST %ProjectName%\NUL MD %ProjectName%
CD %ProjectName%

:directories
IF NOT EXIST DevelopmentTools\NUL MD DevelopmentTools
IF NOT EXIST Configuration\NUL MD Configuration
IF NOT EXIST Support\NUL MD Support
IF NOT EXIST Support\Documentation\NUL MD Support\Documentation

:development
IF NOT EXIST SourceCode\NUL MD SourceCode
CD SourceCode

IF "%SubType%"=="codeigniter" GOTO web
IF "%SubType%"=="web" GOTO web
IF "%SubType%"=="wordpress" GOTO web
IF "%SubType%"=="WordPress" GOTO web
GOTO finish

:web
IF NOT EXIST Web\NUL MD Web

IF "%SubType%"=="wordpress" GOTO database
IF "%SubType%"=="WordPress" GOTO database

IF NOT EXIST LogFiles\NUL MD LogFiles

CALL AppendHosts %ProjectType% %ProjectCode% %ProjectName% %SubProject%
CD %ProjectDirectory%

IF "%SubType%"=="codeigniter" GOTO database
GOTO finish

:database
IF NOT EXIST Database\NUL MD Database
CALL DatabaseCreateEx %dbname% %user% %password%

@ECHO OFF
IF "%SubType%"=="codeigniter" GOTO codeigniter
IF "%SubType%"=="wordpress" GOTO wordpress
IF "%SubType%"=="WordPress" GOTO wordpress
GOTO finish

:codeigniter
cd SourceCode\Web
ECHO Creating composer project
CALL composer create-project kenjis/codeigniter-composer-installer .
PAUSE
@GOTO finish

:wordpress
CALL DatabaseImport %dbname% %user% %password% %ScriptsTemplates%\wordpress-template.fast.sql

SET AuthorEx=%author:"=%

COPY /Y %ScriptsTemplates%\wordpress.composer.json composer.json
sed -i "s|Template|%ProjectName%|g" composer.json
sed -i "s|template|%ProjectNameLowerCase%|g" composer.json
sed -i "s|author-name|%AuthorEx%|g" composer.json
sed -i "s|author-email|%email%|g" composer.json

CD Web
COPY /Y %ScriptsTemplates%\wp-config.php .
sed -i "s|database_name_here|%dbname%|g" wp-config.php
sed -i "s|'username_here'|'%user%'|g" wp-config.php
sed -i "s|password_here|%password%|g" wp-config.php

COPY /Y %ScriptsTemplates%\.htaccess.wordpress .htaccess

IF NOT EXIST themes\NUL MD themes
IF NOT EXIST uploads\NUL MD uploads
IF NOT EXIST Views\NUL MD Views

CD themes
IF NOT EXIST digitalzenworks\NUL MKLINK /D digitalzenworks %USERPROFILE%\Data\Clients\DigitalZenWorks\DigitalZenWorksTheme\SourceCode
IF NOT EXIST digitalzenworks-%ProjectNameLowerCase%\NUL MD digitalzenworks-%ProjectNameLowerCase%
CD digitalzenworks-%ProjectNameLowerCase%
COPY /Y %ScriptsTemplates%\wordpress.style.css style.css
sed -i "s|author|%AuthorEx%|g" style.css
sed -i "s|ThemeDomain|%ProjectNameLowerCase%|g" style.css
sed -i "s|ThemeName|%ProjectName%|g" style.css

COPY /Y %ScriptsTemplates%\functions.php .
sed -i "s|ThemeName|%ProjectName%|g" style.css

CD ..\..\..\..

IF NOT EXIST Tests\NUL MD Tests
CD Tests
COPY /Y %ScriptsTemplates%\phpunit.xml .
COPY /Y %ScriptsTemplates%\PageTests.php .
sed -i "s|Template|%ProjectName%|g" PageTests.php
sed -i "s|author|%AuthorEx%|g" PageTests.php
sed -i "s|email|%email%|g" PageTests.php

ECHO ON
CD ..\DevelopmentTools
COPY /Y %ScriptsTemplates%\Build.cmd .
COPY /Y %ScriptsTemplates%\LocalhostDatabaseCreate.cmd .
sed -i "s|dbname|%dbname%|g" LocalhostDatabaseCreate.cmd
sed -i "s|user|%user%|g" LocalhostDatabaseCreate.cmd
sed -i "s|password|%password%|g" LocalhostDatabaseCreate.cmd

COPY /Y %ScriptsTemplates%\LocalhostDatabaseDump.cmd .
sed -i "s|dbname|%dbname%|g" LocalhostDatabaseDump.cmd
sed -i "s|user|%user%|g" LocalhostDatabaseDump.cmd
sed -i "s|password|%password%|g" LocalhostDatabaseDump.cmd

COPY /Y %ScriptsTemplates%\LocalhostDatabaseUpdate.cmd .
sed -i "s|dbname|%dbname%|g" LocalhostDatabaseUpdate.cmd
sed -i "s|user|%user%|g" LocalhostDatabaseUpdate.cmd
sed -i "s|password|%password%|g" LocalhostDatabaseUpdate.cmd

COPY /Y %ScriptsTemplates%\UnitTests.cmd .

:finish
CD ..\SourceCode\Database
CALL mysqldump --skip-dump-date --complete-insert --extended-insert=FALSE -u %user% --password=%password% %dbname% >%dbname%.sql

ECHO In finish
PAUSE

CD %ProjectDirectory%
REM COPY /Y %ScriptsTemplates%\.gitignore .gitignore
git init
git add .
git add *
git commit -m"Project %ProjectName% %ProjectType% %SubType% type project created"

gh repo create %ProjectName% --description "The %ProjectName% Project." --%Exposure% --source=.

:end
ENDLOCAL

SET author=
SET ClientName=
SET dbname=
SET email=
SET Exposure=
SET password=
SET ProjectCode=
SET ProjectDirectory=
SET ProjectName=
SET ProjectType=
SET SubProject=
SET SubType=
SET Title=
SET user=

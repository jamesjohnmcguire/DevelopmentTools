REM Project Types: Client, SubClient, Project
REM Project SubTypes: Codeigniter, Development, Web, WordPress

@ECHO OFF
C:
CD %~dp0
SET ScriptsHome=%~dp0\Templates

SET ProjectType=%1
SET SubType=%2
SET ProjectName=%3

SET RootUser=root
SET RootPassword=Nvtip7UCzK1U2

SET Exposure=private

SHIFT & SHIFT & SHIFT

:loop
IF NOT "%1"=="" (
	IF "%1"=="-code" (
		SET ProjectCode=%2
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

@ECHO Creating %ProjectName% %ProjectType% %SubType% type project

@IF "%ProjectType%"=="client" TYPE=Clients
@IF "%ProjectType%"=="subclient" TYPE=Clients
@IF "%ProjectType%"=="project" TYPE=Projects

ECHO ON
CD %USERPROFILE%\Data\%TYPE%

IF NOT EXIST %ProjectName%\NUL md %ProjectName%
cd %ProjectName%
SET ProjectDirectory=%USERPROFILE%\Data\%TYPE%\%ProjectName%

IF "%ProjectType%"=="subclient" GOTO subproject
GOTO directories

:subproject
if not exist %SubProject%\NUL md %SubProject%
cd %SubProject%
SET ProjectDirectory=%USERPROFILE%\Data\%TYPE%\%ProjectName%\%SubProject%

:directories
if not exist DevelopmentTools\NUL md DevelopmentTools
if not exist Configuration\NUL md Configuration
if not exist Support\NUL md Support
if not exist Support\Documentation\NUL md Support\Documentation

@IF "%SubType%"=="codeigniter" GOTO development
@IF "%SubType%"=="development" GOTO development
@IF "%SubType%"=="web" GOTO development
@IF "%SubType%"=="wordpress" GOTO development
@goto finish

:development
if not exist SourceCode\NUL md SourceCode
CD SourceCode

@IF "%SubType%"=="codeigniter" GOTO web
@IF "%SubType%"=="web" GOTO web
@IF "%SubType%"=="wordpress" GOTO web
@goto finish

:web
if not exist Web\NUL md Web

@IF "%SubType%"=="wordpress" GOTO database

if not exist LogFiles\NUL md LogFiles

CALL AppendHosts %ProjectType% %ProjectCode% %ProjectName% %SubProject%
cd %ProjectDirectory%

@IF "%SubType%"=="codeigniter" GOTO database
@GOTO finish

:database
ECHO ON
IF NOT EXIST Database\NUL MD Database
CALL DatabaseCreateEx %dbname% %user% %password%

@GOTO continue

:continue
@IF "%SubType%"=="codeigniter" GOTO codeigniter
@IF "%SubType%"=="wordpress" GOTO wordpress
@GOTO finish

:codeigniter
cd SourceCode\Web
echo Creating composer project
CALL composer create-project kenjis/codeigniter-composer-installer .
PAUSE
@GOTO finish

:wordpress
CALL DatabaseImport %dbname% %user% %password% %ScriptsHome%\wordpress-template.fast.sql

CD SourceCode
COPY / Y %ScriptsHome%\wordpress.composer.json composer.json
sed -i "s|Template|%ProjectName%|g" composer.json
sed -i "s|template|%ProjectName%|g" composer.json
sed -i "s|author|%author%|g" composer.json
sed -i "s|email|%email%|g" composer.json

CD Web
COPY / Y %ScriptsHome%\wp-config.php .
sed -i "s|WordPressTemplate|%dbname%|g" wp-config.php
sed -i "s|'WordPress'|'%user%'|g" wp-config.php
sed -i "s|SomePassword123!|%password%|g" wp-config.php

COPY / Y %ScriptsHome%\.htaccess.wordpress .htaccess
MD uploads
MD Views

CD themes
MKLINK /D digitalzenworks %USERPROFILE%\Data\Clients\DigitalZenWorks\DigitalZenWorksTheme\SourceCode
MD digitalzenworks-%ProjectName%
CD digitalzenworks-%ProjectName%
COPY / Y %ScriptsHome%\wordpress.style.css style.css
sed -i "s|ThemeName|%ProjectName%|g" style.css
sed -i "s|author|%author%|g" style.css

CD ..\..\..\..
MD Tests
CD Tests
COPY / Y %ScriptsHome%\phpunit.xml .
COPY / Y %ScriptsHome%\PageTest.php .
sed -i "s|Template|%ProjectName%|g" PageTest.php
sed -i "s|author|%author%|g" PageTest.php
sed -i "s|email|%email%|g" PageTest.php

CD ..\DevelopmentTools
COPY / Y %ScriptsHome%\Build.cmd .
COPY / Y %ScriptsHome%\LocalhostDatabaseCreate.cmd .
sed -i "s|dbname|%dbname%|g" LocalhostDatabaseCreate.cmd
sed -i "s|user|%user%|g" LocalhostDatabaseCreate.cmd
sed -i "s|password|%password%|g" LocalhostDatabaseCreate.cmd

COPY / Y %ScriptsHome%\LocalhostDatabaseDump.cmd .
sed -i "s|dbname|%dbname%|g" LocalhostDatabaseDump.cmd
sed -i "s|user|%user%|g" LocalhostDatabaseDump.cmd
sed -i "s|password|%password%|g" LocalhostDatabaseDump.cmd

COPY / Y %ScriptsHome%\LocalhostDatabaseUpdate.cmd .
sed -i "s|dbname|%dbname%|g" LocalhostDatabaseUpdate.cmd
sed -i "s|user|%user%|g" LocalhostDatabaseUpdate.cmd
sed -i "s|password|%password%|g" LocalhostDatabaseUpdate.cmd

COPY / Y %ScriptsHome%\UnitTests.cmd .

:finish
ECHO ON
CD ..\Database
CALL mysqldump --skip-dump-date --complete-insert --extended-insert=FALSE -u %user% --password=%password% %dbname% >%dbname%.sql

CD %ProjectDirectory%
REM COPY /Y %ScriptsHome%\.gitignore .gitignore
git init
git add .
git add *
git commit -m"Project %ProjectName% %ProjectType% %SubType% type project created"

gh repo create %ProjectName% --description "The %ProjectName% Project." --%Exposure% --source=.

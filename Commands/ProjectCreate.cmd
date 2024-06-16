@ECHO OFF
c:
SET ProjectType=%1
SET SubType=%2
SET ProjectName=%3

SET RootUser=root
SET RootPassword=Nvtip7UCzK1U2

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
@IF "%SubType%"=="wp" GOTO development
@goto finish

:development
if not exist SourceCode\NUL md SourceCode
CD SourceCode

@IF "%SubType%"=="codeigniter" GOTO web
@IF "%SubType%"=="web" GOTO web
@IF "%SubType%"=="wordpress" GOTO web
@IF "%SubType%"=="wp" GOTO web
@goto finish

:web
if not exist Web\NUL md Web

@IF "%SubType%"=="wp" GOTO database

if not exist LogFiles\NUL md LogFiles

CALL AppendHosts %ProjectType% %ProjectCode% %ProjectName% %SubProject%
cd %ProjectDirectory%

@IF "%SubType%"=="wordpress" GOTO database
@IF "%SubType%"=="codeigniter" GOTO database
@goto finish

:database
ECHO ON
if not exist Database\NUL md Database
CALL DatabaseCreateEx %dbname% %user% %password%

@IF "%SubType%"=="wordpress" GOTO wordpress
@goto continue

:wordpress
cd SourceCode\Web
COPY /Y C:\Users\JamesMc\Data\Commands\wordpress.composer.json composer.json
CALL composer install --prefer-dist

cd wp
REM Not needed
REM CALL wp core download
CALL wp core config --dbname=%dbname% --dbuser=%user% --dbpass=%password%
CALL wp core install --url=http://%ProjectCode%.localhost/ --title=%Title% --admin_user=%user% --admin_password=%password% --admin_email=%email%
CALL wp core update
CALL wp theme update --all
CALL wp plugin update --all
CALL move /Y index.php ..

REM Maybe another day, too problematic for now..
REM CALL move /Y wp-content ..

cd ..
sed -i "s|wp-blog-header|wp\/wp-blog-header|g" index.php
CALL wp config set WP_CONTENT_DIR "__DIR__ . '/wp-content'" --type=constant --raw
CALL wp option update siteurl http://%ProjectCode%.localhost/wp
pause

:continue
@IF "%SubType%"=="codeigniter" GOTO codeigniter
@IF "%SubType%"=="wp" GOTO wordpress-import
@goto database_save

:codeigniter
cd SourceCode\Web
echo Creating composer project
CALL composer create-project kenjis/codeigniter-composer-installer .
PAUSE
@goto database_save

:wordpress-import
CALL DatabaseImport %dbname% %user% %password% %USERPROFILE%\Data\Commands\wordpress-template.fast.sql

COPY %USERPROFILE%\Data\Commands\wp-config.php Web
CD Web
sed -i "s|WordPressTemplate|%dbname%|g" wp-config.php
sed -i "s|'WordPress'|'%user%'|g" wp-config.php
sed -i "s|SomePassword123!|%password%|g" wp-config.php

@GOTO finish

:database_save
ECHO ON
cd ..\Database
CALL mysqldump --skip-dump-date --complete-insert --extended-insert=FALSE -u %user% --password=%password% %dbname% >%dbname%.sql

:finish
cd %ProjectDirectory%
COPY /Y %USERPROFILE%\Data\Commands\.gitignore .gitignore
git init
git add .
git add *
git commit -m"Project %ProjectName% %ProjectType% %SubType% type project created"

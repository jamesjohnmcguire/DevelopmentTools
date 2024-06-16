REM AppendHosts <SubDomain> <OrganizationName>
REM AppendHosts <SubDomain> <OrganizationName> <ProjectName>
REM AppendHosts <SubDomain> <OrganizationName> <SubOrganization>
REM AppendHosts <SubDomain> <OrganizationName> <SubOrganization> <ProjectName>
SET ProjectType=%1
@IF "%ProjectType%"=="client" GOTO clients
@IF "%ProjectType%"=="subclient" GOTO clients
@IF "%ProjectType%"=="project" GOTO projects

:clients
SET TYPE=Clients
@GOTO continue

:projects
SET TYPE=Projects
@GOTO continue

:continue
cd C:\Windows\System32\drivers\etc
if exist "hosts.bak" del hosts.bak
copy hosts hosts.bak

echo 	127.0.0.1	localhost	%2.localhost >>C:\Windows\System32\drivers\etc\hosts

SET directory=%USERPROFILE%\Data\%TYPE%\%3

@IF "%ProjectType%"=="subclient" SET directory=%directory%\%4

SET LogFiles=%directory%\%LogFiles
SET directory=%directory%\SourceCode\Web

echo %directory%
SET NonQuotedPath=%directory:"=%
SET NonQuotedLogsPath=%LogFiles:"=%

cd %ApachePath%\conf\extra
if exist "httpd-vhosts.conf.bak" del httpd-vhosts.conf.bak
copy httpd-vhosts.conf httpd-vhosts.conf.bak

echo # %2>>httpd-vhosts.conf
echo ^<VirtualHost %2.localhost:80^> >>httpd-vhosts.conf
echo 	DocumentRoot "%NonQuotedPath%">>httpd-vhosts.conf
echo 	ServerName %2.localhost>>httpd-vhosts.conf
echo 	ErrorLog "%NonQuotedLogsPath%\error.log">>httpd-vhosts.conf
echo 	CustomLog "%NonQuotedLogsPath%\access.log" combined>>httpd-vhosts.conf
echo 	Options Indexes FollowSymLinks Includes ExecCGI>>httpd-vhosts.conf
echo 	AcceptPathInfo On>>httpd-vhosts.conf
echo 	^<Directory "%NonQuotedPath%"^> >>httpd-vhosts.conf
echo 		Options All>>httpd-vhosts.conf
echo 		AllowOverride All>>httpd-vhosts.conf
echo 		Require all granted>>httpd-vhosts.conf
echo 		Allow from 127.0.0.1>>httpd-vhosts.conf
echo 	^</Directory^> >>httpd-vhosts.conf
echo ^</VirtualHost^> >>httpd-vhosts.conf

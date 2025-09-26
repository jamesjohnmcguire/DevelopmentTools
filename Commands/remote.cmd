@ECHO OFF
SETLOCAL

SET command=%1
SET remoteServer=%2
SET remoteUser=%3
SET remoteAuthentication=%4 %5
SET remotePath=%6
SET scpFile=%7

SET recurse=false
SET verbose=false

FOR %%i IN (%*) DO (
	IF /i "%%i"=="recurse" SET recurse=true
	IF /i "%%i"=="verbose" SET verbose=true
)

IF NOT [%remotePort%]==[] SET remotePort=-P 22
IF %recurse%==true SET remoteOptions=-r

IF %verbose%==true GOTO verbose
GOTO end

:verbose
ECHO Verbose Is: ON
ECHO Options Are: %remoteOptions%
ECHO Port Is: %remotePort%
ECHO Remote Server Is: %remoteServer%
ECHO Remote User Is: %remoteUser%
ECHO Remote Authentication Is: %remoteAuthentication%
ECHO Remote Path Is: %remotePath%
ECHO File Is: %scpFile%

IF %command%==get GOTO get
IF %command%==put GOTO put

:get
IF %verbose%==true ECHO Command Is: pscp %remoteAuthentication% %remotePort% %remoteOptions% %remoteUser%@%remoteServer%:%remotePath%/%scpFile% %scpFile%

pscp %remoteAuthentication% %remotePort% %remoteOptions% %remoteUser%@%remoteServer%:%remotePath%/%scpFile% %scpFile%
GOTO end

:put
IF %verbose%==true ECHO Command Is: pscp %remoteAuthentication% %remotePort% %remoteOptions% %scpFile% %remoteUser%@%remoteServer%:%remotePath%

pscp %remoteAuthentication% %remotePort% %remoteOptions% %scpFile% %remoteUser%@%remoteServer%:%remotePath%
GOTO end

:usage
ECHO Usage: remote [get | put] [server] [user] [authentication type] [authentication parameter] [remote path] [file] <<recurse | verbose>>

:end
ENDLOCAL

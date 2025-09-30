@ECHO OFF
SETLOCAL

SET command=%1
SET remoteServer=%2
SET remoteUser=%3
SET remoteAuthentication=%4 %5

CALL remoteBaseOptions.cmd %*

IF NOT [%remotePort%]==[] SET remotePort=-P 22
IF %recurse%==true SET remoteOptions=-r

IF %verbose%==true GOTO verbose
GOTO continue

:verbose
ECHO Verbose Is: ON
ECHO Options Are: %remoteOptions%
ECHO Port Is: %remotePort%
ECHO Remote Server Is: %remoteServer%
ECHO Remote User Is: %remoteUser%
ECHO Remote Authentication Is: %remoteAuthentication%

:continue
IF %command%==command GOTO command
IF %command%==get GOTO get
IF %command%==put GOTO put

:command
SET remoteCommand=%6
ECHO command is: [96m%remoteCommand%[0m

:: plink.exe -v
REM plink.exe -ssh -t -%Mode% %ServerUser% %Authorization% %remoteCommand%
GOTO end

:get
SET remotePath=%6
SET scpFile=%7
IF %verbose%==true ECHO Remote Path Is: %remotePath%
IF %verbose%==true ECHO File Is: %scpFile%

IF %verbose%==true ECHO Command Is: pscp %remoteAuthentication% %remotePort% %remoteOptions% %remoteUser%@%remoteServer%:%remotePath%/%scpFile% %scpFile%

pscp %remoteAuthentication% %remotePort% %remoteOptions% %remoteUser%@%remoteServer%:%remotePath%/%scpFile% %scpFile%
GOTO end

:put
SET remotePath=%6
SET scpFile=%7
IF %verbose%==true ECHO Remote Path Is: %remotePath%
IF %verbose%==true ECHO File Is: %scpFile%

IF %verbose%==true ECHO Command Is: pscp %remoteAuthentication% %remotePort% %remoteOptions% %scpFile% %remoteUser%@%remoteServer%:%remotePath%

pscp %remoteAuthentication% %remotePort% %remoteOptions% %scpFile% %remoteUser%@%remoteServer%:%remotePath%
GOTO end

:usage
ECHO Usage: remote [get | put] [server] [user] [authentication type] [authentication parameter] [remote path] [file] <<recurse | verbose>>

:end
ENDLOCAL

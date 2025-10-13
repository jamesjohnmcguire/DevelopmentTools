CD %~3

IF "%1"=="dotnet" GOTO dotnet
IF "%1"=="msbuild" GOTO msbuild
GOTO end

:dotnet
IF EXIST Release\NUL rd /s /q Release

SET config=--configuration Release
SET output=--output Release\win-x64
SET pack=-p:PublishReadyToRun=true -p:PublishSingleFile=true --self-contained
SET runtime=--runtime win-x64

:dotnet-publish
dotnet publish %config% %output% %pack% %runtime% %4

::IF "%2"=="publish" GOTO dotnet-publish
IF "%2"=="release" GOTO dotnet-release
GOTO end

:dotnet-release
SET output=--output Release\linux-x64
SET runtime=--runtime linux-x64
dotnet publish %config% %output% %pack% %runtime% %4

SET output=--output Release\osx-x64
SET runtime=--runtime osx-x64
dotnet publish %config% %output% %pack% %runtime% %4

CD Release\linux-x64
7z u %4-linux-x64.zip .
MOVE %4-linux-x64.zip ..

CD ..\osx-x64
7z u %4-osx-x64.zip .
MOVE %4-osx-x64.zip ..

CD ..\win-x64
7z u %4-win-x64.zip .
MOVE %4-win-x64.zip ..

CD ..
gh release create v%5 --notes %6 *.zip

:msbuild
IF EXIST Release\NUL rd /s /q Release

:end

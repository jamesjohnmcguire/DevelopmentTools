SET utils=%USERPROFILE%\Data\Commands

IF "%1"=="net5" GOTO net5
GOTO netcore

:net5
SET source=%USERPROFILE%\Data\Clients\DigitalZenWorks\IssueTests\nunit-console\bin\Release\net5.0
GOTO finish

:netcore
SET source=%USERPROFILE%\Data\Clients\DigitalZenWorks\IssueTests\nunit-console\bin\Debug\netcoreapp3.1

:finish
xcopy /D /E /H /I /R /S /Y %source% %utils%

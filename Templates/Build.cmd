CD %~dp0
CD ..\SourceCode

CALL composer validate --strict
CALL composer install --prefer-dist
ECHO outdated:
CALL composer outdated

REM ECHO Checking code styles...
REM php vendor\bin\phpcs -sp --standard=ruleset.xml .

CALL UnitTests.cmd

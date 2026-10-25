ECHO.
ECHO Checking composer...
CALL composer install --prefer-dist
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
CALL composer validate --strict
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%

ECHO.
ECHO Outdated:
CALL composer outdated --direct
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%

ECHO.
ECHO Security audit:
CALL composer audit
EXIT /B %ERRORLEVEL%

ECHO.
ECHO Checking npm...
CALL npm install
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%

ECHO.
ECHO Outdated:
CALL npm outdated --depth=0

ECHO.
ECHO Security audit (high level):
CALL npm audit --audit-level=high
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%

ECHO.
ECHO Security audit (normal level):
CALL npm audit
EXIT /B %ERRORLEVEL%

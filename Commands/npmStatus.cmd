ECHO.
ECHO Checking npm...
CALL npm install
ECHO.
ECHO Outdated:
CALL npm outdated --depth=0
ECHO.
ECHO Security audit (high level):
CALL npm audit --audit-level=high
ECHO.
ECHO Security audit (normal level):
CALL npm audit

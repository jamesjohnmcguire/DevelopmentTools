ECHO.
ECHO Checking composer...
CALL composer install --prefer-dist
CALL composer validate --strict
ECHO.
ECHO Outdated:
CALL composer outdated --direct
ECHO.
ECHO Security audit:
CALL composer audit

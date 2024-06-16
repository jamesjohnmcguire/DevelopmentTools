SET HTTP_HOST=localhost

ECHO Xampp
CD \Util\Xampp\htdocs
CALL wp core update
CALL wp plugin update --all
CALL wp theme update --all

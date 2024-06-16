@if [%5]==[] GOTO usage

SET server=%3
SET user=%4
SET file=%5

if [%6]==[] SET port=22
if not [%6]==[] SET port=%6
if [%7]==[] SET key=
if not [%7]==[] SET key=-i %7

@@IF "%1"=="get" GOTO get
@@IF "%1"=="put" GOTO put

@GOTO end

:get
@IF "%2"=="conf" GOTO get_conf
@IF "%2"=="theme" GOTO get_theme
@GOTO end

:get_conf
IF [%server%]==[160.16.227.180] SET remotePath=/etc/apache2/sites-available

CALL pscp -P %port% %key% %user%@%server%:%remotePath%/%file% .\%file%
@GOTO end

:get_theme
IF [%server%]==[160.16.227.180] SET remotePath=/home/psynary/www/wp-content/themes/psynary

CALL pscp -P %port% %key% %user%@%server%:%remotePath%/%file% .\%file%
@GOTO end

:put
@IF "%2"=="conf" GOTO put_conf
@IF "%2"=="js" GOTO put_js
@GOTO end

:put_conf
IF [%server%]==[160.16.227.180] SET remotePath=/etc/apache2/sites-available
call pscp -P %port% %key% %file% %user%@%server%:%remotePath%

@GOTO end

:put_js
IF [%server%]==[160.16.227.180] SET remotePath=/home/psynary/www/wp-content/themes/psynary/js
call pscp -P %port% %key% %file% %user%@%server%:%remotePath%

@GOTO end

:usage
ECHO "ERROR usage: remote [get | put] [type] [server] [user] [file] [port] [key]"
:end

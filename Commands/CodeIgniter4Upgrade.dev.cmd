REM Start in the root of the project

IF %CodeIgniter4Template%=[] SET CodeIgniter4Template=%USERPROFILE%\Data\Clients\DigitalZenWorks\Libraries\PHP\CodeIgniter4AppStarter
CD SourceCode\Web
PAUSE

CALL CopyRn %CodeIgniter4Template%\public public
CALL CopyRn %CodeIgniter4Template%\tests tests
CALL CopyRn %CodeIgniter4Template%\vendor vendor
CALL CopyRn %CodeIgniter4Template%\writable writable

COPY /Y %CodeIgniter4Template%\.gitignore .
COPY /Y %CodeIgniter4Template%\builds .
COPY /Y %CodeIgniter4Template%\composer.* .
COPY /Y %CodeIgniter4Template%\LICENSE .
COPY /Y %CodeIgniter4Template%\phpunit.xml.dist .
COPY /Y %CodeIgniter4Template%\preload.php .
COPY /Y %CodeIgniter4Template%\README.md .
COPY /Y %CodeIgniter4Template%\spark .

ECHO You may want to commit at this point (Many more to go)
PAUSE

COPY /Y %CodeIgniter4Template%\env .env
ECHO Edit .env as needed
PAUSE

ECHO You may want to commit at this point (Many more to go)
PAUSE

# Deal with app
REN application app
CD app
COPY /Y %CodeIgniter4Template%\app\.htaccess .
COPY /Y %CodeIgniter4Template%\app\Common.php .
COPY /Y %CodeIgniter4Template%\app\index.html .

CALL CopyRn %CodeIgniter4Template%\app\Database Database
CALL CopyRn %CodeIgniter4Template%\app\Filters Filters

RD /S /Q cache
RD /S /Q logs
git rm -r hooks

git mv config Config
git mv controllers Controllers
git mv helpers Helpers
git mv language Language
git mv libraries Libraries
git mv models Models
git mv third_party ThirdParty
git mv views Views

# commit ?

# TODO Deal with core
PAUSE

# Eventually
git rm -r core

# commit ?

CD Config
git rm index.html
git rm hooks.php
git rm memcached.php
git rm profiler.php
git rm smileys.php

CALL CopyRn %CodeIgniter4Template%\app\Config\Boot Boot

COPY /Y %CodeIgniter4Template%\app\Config\App.php .
COPY /Y %CodeIgniter4Template%\app\Config\Cache.php .
COPY /Y %CodeIgniter4Template%\app\Config\ContentSecurityPolicy.php  .
COPY /Y %CodeIgniter4Template%\app\Config\Email.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Encryption.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Events.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Exceptions.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Filters.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Format.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Honeypot.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Images.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Kint.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Logger.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Modules.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Pager.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Paths.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Services.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Toolbar.php . 
COPY /Y %CodeIgniter4Template%\app\Config\Validation.php . 
COPY /Y %CodeIgniter4Template%\app\Config\View.php .

# commit ?

Unfinished
Merge
git mv autoload.php Autoload.php
# consider finding alternate for $autoload['libraries'] = array('session');
# consider finding alternate for $autoload['helper'] = array('url');

# commit ?
PAUSE
COPY /Y %CodeIgniter4Template%\app\Config\Autoload.php .

git mv constants.php Constants.php
git mv database.php Database.php
git mv doctypes.php DocTypes.php
git mv foreign_chars.php ForeignCharacters.php
git mv migration.php Migrations.php
git mv mimes.php Mimes.php
git mv routes.php Routes.php
git mv user_agents.php UserAgents.php

# commit ?

# Autoload.php
# consider finding alternate for $autoload['libraries'] = array('session');
# consider finding alternate for $autoload['helper'] = array('url');
COPY /Y %CodeIgniter4Template%\app\Config\Autoload.php .
??
config.php
SED -i "s|defined('BASEPATH') OR exit('No direct script access allowed');||g" *.php


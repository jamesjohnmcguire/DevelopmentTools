@ECHO ON
mysql --default-character-set=utf8 --show-warnings -u %1 --password=%2 -e "CREATE DATABASE `%3`"
mysql --default-character-set=utf8 --show-warnings -u %1 --password=%2 -e "use `%3`; GRANT ALL PRIVILEGES ON `%3`.* to `%4`@localhost IDENTIFIED BY '%5'"

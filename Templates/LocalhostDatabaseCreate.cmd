CALL MySqlRootCommand "DROP DATABASE IF EXISTS `dbname`;"

CALL DatabaseCreateEx dbname user password
LocalhostDatabaseUpdate

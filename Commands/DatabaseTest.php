<?php
echo "begin\r\n";

$argv = $GLOBALS['argv'];

$hostName = $argv[1];
$databaseName = $argv[2];
$username = $argv[3];
$password = $argv[4];

$database	= new mysqli($hostName, $username, $password, $databaseName);

$error = mysqli_connect_error();
if (!empty($error))
{
	echo "ERROR: DBTEST Error: $error\r\n";
}
else
{
	echo "DatabaseLib::DatabaseLib connection ok\r\n";
}

<?php
function RecurseDirectories($dir)
{
	// echo "RecurseDirectories checking $dir<br />\r\n";
	$result = array();

	$files = scandir($dir);
	foreach ($files as $file)
	{
		// echo "RecurseDirectories checking file $file<br />\r\n";
		$excludes = ['.', '..'];

		if (!in_array($file, $excludes))
		{
			$path = $dir . DIRECTORY_SEPARATOR . $file;
			if (is_dir($path))
			 {
				RecurseDirectories($path);
			 }
			 else
			 {
				$result = RemoveIfEmptyFile($path);
				
				if ($result == true)
				{
					echo "$path is empty and deleted.<br>\r\n";
				}
			 }
		}
	}
}

function RemoveIfEmptyFile($file)
{
	$result = false;

	$size = filesize($file);

	if ($size === 0)
	{
		unlink($file);
		$result = true;
	}

	return $result;
}

error_reporting(-1);
ini_set('display_errors', 1);

$current = getcwd();
echo "Checking at: $current<br />\r\n";

RecurseDirectories($current);

echo "Empty Files Removed Finish.<br>\r\n";

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET Text=%2

IF "%1"=="lower" GOTO lower
IF "%1"=="upper" GOTO upper

GOTO :finish

:lower
SET LowerCases=a b c d e f g h i j k l m n o p q r s t u v w x y z
FOR %%Z IN (%LowerCases%) DO SET Text=!Text:%%Z=%%Z!

GOTO :finish

:upper
SET UpperCase=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
FOR %%Z IN (%UpperCase%) DO SET Text=!Text:%%Z=%%Z!

GOTO :finish

:finish
SET Result=%Text%
ECHO %Result%
ENDLOCAL

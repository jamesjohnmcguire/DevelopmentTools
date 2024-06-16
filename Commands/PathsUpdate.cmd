CALL go home

CD ProgramData\ComputerEnvironment

sed ":a;N;$!ba;s|\n|\;|g" SystemPath.txt >SystemPath.out.txt
sed ":a;N;$!ba;s|\n|\;|g" UserPath.txt >UserPath.out.txt

set /p Import=<UserPath.out.txt
reg add HKCU\Environment /t REG_EXPAND_SZ /v Path /f /d %Import%

set /p Import=<SystemPath.out.txt
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /t REG_EXPAND_SZ /v Path /f /d %Import%

if [%6]==[] SET mode=binary
if not [%6]==[] SET mode=%6

echo open %1> FtpTempScript.txt
echo %2>> FtpTempScript.txt
echo %3>> FtpTempScript.txt

echo cd %4>> FtpTempScript.txt
echo %mode%>> FtpTempScript.txt
echo mput %5>> FtpTempScript.txt
rem echo .>> FtpTempScript.txt

echo quit>> FtpTempScript.txt

ftp -i -d -s:FtpTempScript.txt

DEL /Q FtpTempScript.txt

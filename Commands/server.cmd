@ECHO OFF
SET ServerUser=%1
SET Authorization=%2 %3
SET Port=%4
SET command="%~5"
ECHO command is: %command%

@ECHO ON
plink.exe -v -ssh -t -batch %ServerUser% %Authorization% -P %Port% %command%

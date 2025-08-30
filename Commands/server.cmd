@ECHO OFF
SET Mode=batch
SET ServerUser=%1
SET Authorization=%2 %3
SET Port=%4
SET command="%~5"

IF NOT [%6]==[] SET Mode=agent


ECHO command is: [96m%command%[0m

:: plink.exe -v
plink.exe -ssh -t -%Mode% %ServerUser% %Authorization% -P %Port% %command%

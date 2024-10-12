@ECHO OFF
SET Mode=batch
SET ServerUser=%1
SET Authorization=%2 %3
SET Port=%4
SET command="%~5"

IF NOT [%6]==[] SET Mode=agent


ECHO command is: %command%

@ECHO ON
plink.exe -v -ssh -t -%Mode% %ServerUser% %Authorization% -P %Port% %command%

SET ServerUser=%2@%1
SET Authentication=%3 %4
SET Port=%5
SET RemotePath=%6
SET LocalPath=%7

pscp -P %Port% %Authentication% -r %ServerUser%:%RemotePath%/* %LocalPath%

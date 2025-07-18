@ECHO ON
SET ServerUser=%2@%1
SET Authentication=%3 %4
SET Port=%5
SET RemotePath=%6
SET File=%7
SET LocalFile=%8
SET Options=%9

pscp -P %Port% %Authentication% %Options% %ServerUser%:%RemotePath%/%file% %LocalFile%

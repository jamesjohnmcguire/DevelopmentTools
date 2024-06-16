@echo off
rem for /f "usebackq delims=" %%d in (`"dir /ad/b/s | sort /R"`) do dir "%%d"
REM for /f "usebackq" %%d in (`"dir /ad/b/s | sort /R"`) do rd "%%d"
REM for /f "usebackq delims=" %%d in (`"dir /ad/b/s | sort /R"`) do rd "%%d"
FOR /F delims^= %%A IN ('DIR/AD/B/S^|SORT/R') DO RD "%%A" >NUL 2>NUL

SET recurse=false
SET verbose=false

:process
IF "%1"=="" GOTO :done

IF /i "%1"=="recurse" SET recurse=true
IF /i "%1"=="verbose" SET verbose=true

:: Shift arguments to bring the next one into %1
shift
GOTO :process

:done

SETLOCAL
CD %WebRoot%

SET Id=%~1

:: File containing the fields concatenated together
SET Post=%~2

:: File containing the form structure as HTML fragment
SET Form=%~3

:: Should be in JSON format
SET Mail1Settings=%~4
SET Mail2Settings=%~5

:: Text file with paired data like "key=value",
:: Such as: flamingo_email: "[your-email]"
SET AdditionalSettings=%~5

IF NOT EXIST "%Post%" SET ErrorMessage="Input file not found: %Post%"
IF NOT EXIST "%Post%" GOTO error
IF NOT EXIST "%Form%" SET ErrorMessage="Input file not found: %Form%"
IF NOT EXIST "%Form%" GOTO error
IF NOT EXIST "%Mail1Settings%" SET ErrorMessage="Input file not found: %Mail1Settings%"
IF NOT EXIST "%Mail1Settings%" GOTO error

@ECHO ON
CALL wp post update %Id% "%Post%"
@ECHO ON
CALL wp post meta update %Id% _form < "%Form%"

@ECHO ON
CALL wp post meta update --format=json %Id% _mail < "%Mail1Settings%"

:: Optional second mail settings file
@IF "%Mail2Settings%"=="none" GOTO additional
IF NOT EXIST "%Mail1Settings%" GOTO additional

@ECHO ON
CALL wp post meta update --format=json %Id% _mail_2 < "%Mail2Settings%"

:additional
@ECHO ON
IF "%AdditionalSettings%"=="" GOTO finish
CALL wp post meta update %Id% _additional_settings < "%AdditionalSettings%"
GOTO finish

:error
SET LocalErrorLevel=1
ECHO ERROR: %ErrorMessage%

:finish
ENDLOCAL & EXIT /B %LocalErrorLevel%

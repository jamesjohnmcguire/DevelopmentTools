CD %WebRoot%

SET Id=%1

:: File containing the form structure as HTML fragment
SET Form=%2

:: Text file with paired data like "key=value",
:: Such as: flamingo_email: "[your-email]"
SET AdditionalSettings=%3

:: Should be in JSON format
SET Mail1Settings=%4
SET Mail2Settings=%5

@ECHO ON

CALL wp post update %Id% %2
@ECHO ON
CALL wp post meta update %Id% _form < %Form%
@ECHO ON
CALL wp post meta update %Id% _additional_settings < %AdditionalSettings%
@ECHO ON
CALL wp post meta update --format=json %Id% _mail < %Mail1Settings%
@ECHO ON

:: Type is a static holder type but is neither static nor NotInheritable
dotnet format --diagnostics CA1052 --verbosity detailed
PAUSE

:: types can be made internal
dotnet format --diagnostics CA1515 --verbosity detailed
PAUSE

dotnet format --diagnostics CA1815 --verbosity detailed
PAUSE

:: Remove Unused Fields
dotnet format --diagnostics CA1823 --verbosity detailed
PAUSE

::Code should not contain trailing whitespace
dotnet format --diagnostics SA1028 --verbosity detailed
PAUSE

:: Opening parenthesis or bracket should be on declaration line
dotnet format --diagnostics SA1110 --verbosity detailed
PAUSE
:: 
:: Closing parenthesis should be on line of last parameter
dotnet format --diagnostics SA1111 --verbosity detailed

:: Format Parameters Consistently
dotnet format --diagnostics SA1116 --verbosity detailed
PAUSE

:: SA1119 StatementMustNotUseUnnecessaryParenthesis
dotnet format --diagnostics SA1119 --verbosity detailed
PAUSE

:: SA1121UseBuiltInTypeAlias
dotnet format --diagnostics SA1121 --verbosity detailed
PAUSE

:: Use String.Empty
dotnet format --diagnostics SA1122 --verbosity detailed
PAUSE

:: unnecessary using
dotnet format --diagnostics SA1128 --verbosity detailed
PAUSE

:: Constant values should appear on the right-hand side of comparisons
dotnet format --diagnostics SA1131 --verbosity detailed
PAUSE

:: Each attribute should be placed in its own set of square brackets
dotnet format --diagnostics SA1133 --verbosity detailed
PAUSE

:: Elements should have the same indentation
dotnet format --diagnostics SA1137 --verbosity detailed
PAUSE

:: Using directive should appear within a namespace declaration
dotnet format --diagnostics SA1200 --verbosity detailed
PAUSE

:: using order
:: Using directive for 'System.*' should appear before directive for
dotnet format --diagnostics SA1208 --verbosity detailed
PAUSE

:: Using directives should be ordered alphabetically by the namespaces
dotnet format --diagnostics SA1210 --verbosity detailed
PAUSE

:: Element should begin with an uppercase letter
dotnet format --diagnostics SA1300 --verbosity detailed
PAUSE

:: Element should not begin with a Prefix
dotnet format --diagnostics SA1308 --verbosity detailed
PAUSE

:: Variable should begin with lower-case letter
dotnet format --diagnostics SA1312 --verbosity detailed
PAUSE

:: ParameterNamesMustBeginWithLowerCaseLetter
dotnet format --diagnostics SA1313 --verbosity detailed
PAUSE

:: Element should declare an access modifier
dotnet format --diagnostics SA1400 --verbosity detailed
PAUSE

:: An opening brace should not be followed by a blank line
dotnet format --diagnostics SA1505 --verbosity detailed
PAUSE

:: Remove Extra New Lines
dotnet format --diagnostics SA1507 --verbosity detailed
PAUSE

:: A closing brace should not be preceded by a blank line
dotnet format --diagnostics SA1508 --verbosity detailed
PAUSE

:: Ensure Extra New Line After Closing Brace
dotnet format --diagnostics SA1513 --verbosity detailed
PAUSE

:: Element Documentation Header Should Be Proceeded by a Blank Line
dotnet format --diagnostics SA1514 --verbosity detailed
PAUSE

:: Elements Must Be Separated By Blank Line
dotnet format --diagnostics SA1516 --verbosity detailed
PAUSE

:: Do not use documentation style slashes
dotnet format --diagnostics SA1626 --verbosity detailed
PAUSE

:: Ensure All Documentation ends with a period.
dotnet format --diagnostics SA1629 --verbosity detailed
PAUSE

:: File Must Have Header
dotnet format --diagnostics SA1633 --verbosity detailed
PAUSE

:: Each Attribute Should Be on It's Own Line
dotnet format --diagnostics SA1638 --verbosity detailed

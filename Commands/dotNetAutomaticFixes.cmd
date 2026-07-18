:: =============================================================================
:: dotnet format - Comprehensive Auto-Fixable Diagnostics Script
:: =============================================================================
:: Run each block independently or comment out sections you don't need.
:: Requires: .NET 6+ SDK (dotnet format is built-in)
:: Requires: StyleCop.Analyzers NuGet package for SA* rules
::
:: Usage: dotNetAutomaticFixes.bat [path\to\solution.sln]
:: =============================================================================

:: To run ALL rules in one shot (no pauses), use:
:: dotnet format %TARGET% --severity info --verbosity detailed

@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: The "is using configuration from '...editorconfig'" line repeats once
:: per project, per invocation, at --verbosity detailed. Filtered out here.
SET filterText="is using configuration from"
SET filterCommand=findstr /v /c:%filterText%

SET "location=."
SET "progressFile=%location%\.dotnet-fixes"
SET "reset=false"

IF NOT "%~1"=="" GOTO check
GOTO :main

:check
IF /I NOT "%~1"=="--reset" SET "location=%~1"
IF /I "%~1"=="--reset" SET "reset=true"
IF /I "%~2"=="--reset" SET "reset=true"

if "%reset%"=="true" GOTO :reset
GOTO :continue

:reset
IF EXIST "%progressFile%" DEL /Q "%progressFile%"
ECHO Progress reset via --reset. Starting from the beginning.

:continue
IF NOT EXIST "%progressFile%" goto :main

FOR /F %%C IN ('FIND /C /V "" ^< "%progressFile%"') DO SET doneCount=%%C
IF "%doneCount%"=="0" GOTO :main

ECHO Found previous progress: %doneCount% rule(s) already completed.

:main
ECHO.
ECHO ===========================================================================
ECHO CA CODE QUALITY RULES (Microsoft.CodeAnalysis.NetAnalyzers)
ECHO ===========================================================================

:: --- Style / Maintainability ---
CALL :run CA1052 "Type is a static holder type but is neither static nor NotInheritable"
CALL :run CA1507 "Use nameof instead of hardcoded string literal for member name"
CALL :run CA1510 "Use ArgumentNullException throw helper"
CALL :run CA1511 "Use ArgumentException throw helper"
CALL :run CA1512 "Use ArgumentOutOfRangeException throw helper"
CALL :run CA1513 "Use ObjectDisposedException throw helper"
CALL :run CA1515 "Types can be made internal"
CALL :run CA2208 "Instantiate argument exceptions correctly"
CALL :run CA2211 "Non-constant fields should not be visible (make const or readonly)"
CALL :run CA2245 "Do not assign a property to itself"
CALL :run CA2249 "Consider using String.Contains instead of String.IndexOf"

CALL :run CA1815 "???"

:: --- Performance ---
CALL :run CA1802 "Use literals where appropriate (static readonly → const)"
CALL :run CA1805 "Do not initialize unnecessarily (default value assignments)"
CALL :run CA1812 "Avoid uninstantiated internal classes"
CALL :run CA1823 "Remove unused private fields"
CALL :run CA1825 "Avoid zero-length array allocations (use Array.Empty<T>())"
CALL :run CA1826 "Do not use Enumerable methods on indexable collections (use indexer)"
CALL :run CA1827 "Do not use Count()/LongCount() when Any() can be used"
CALL :run CA1828 "Do not use CountAsync/LongCountAsync when AnyAsync can be used"
CALL :run CA1829 "Use Length/Count instead of Enumerable.Count()"
CALL :run CA1830 "Prefer strongly-typed StringBuilder.Append overloads"
CALL :run CA1831 "Use AsSpan instead of Range-based indexer for string"
CALL :run CA1832 "Use AsSpan instead of Range-based indexer for array"
CALL :run CA1833 "Use AsSpan instead of Range-based indexer (Memory overload)"
CALL :run CA1834 "Use StringBuilder.Append(char) for single-character strings"
CALL :run CA1835 "Prefer the 'Memory'-based overloads for ReadAsync/WriteAsync"
CALL :run CA1836 "Prefer IsEmpty over Count"
CALL :run CA1837 "Use Environment.ProcessId instead of Process.GetCurrentProcess().Id"
CALL :run CA1838 "Avoid StringBuilder parameters for P/Invokes"
CALL :run CA1841 "Prefer Dictionary.Contains methods"
CALL :run CA1845 "Use span-based string.Concat and AsSpan instead of Substring"
CALL :run CA1846 "Prefer AsSpan over Substring when span-based overloads are available"
CALL :run CA1847 "Use string.Contains(char) instead of string.Contains(string)"
CALL :run CA1852 "Seal internal types"
CALL :run CA1854 "Prefer Dictionary.TryGetValue"
CALL :run CA1855 "Prefer Clear() over Fill() to clear spans"
CALL :run CA1860 "Avoid using Enumerable.Any() — use Length, Count, or IsEmpty"
CALL :run CA1861 "Avoid constant arrays as arguments"
CALL :run CA1862 "Use StringComparison.OrdinalIgnoreCase overloads"
CALL :run CA1863 "Use CompositeFormat"
CALL :run CA1864 "Prefer the IDictionary.TryAdd(key, value) method"
CALL :run CA1865 "Use string.Method(char) instead of string.Method(string)"
CALL :run CA1868 "Unnecessary call to Contains for sets"
CALL :run CA1869 "Cache and reuse JsonSerializerOptions"

:: --- Reliability ---
CALL :run CA2016 "Forward the CancellationToken parameter to methods that take one"

ECHO.
ECHO ===========================================================================
ECHO IDE STYLE RULES (Roslyn / Microsoft.CodeAnalysis)
ECHO These are part of the built-in .NET SDK analyzers.
ECHO ===========================================================================

:: --- Simplification & Unnecessary Code ---
CALL :run IDE0001 "Simplify type name (e.g. System.IO.FileInfo → FileInfo)"
CALL :run IDE0002 "Simplify member access (e.g. remove redundant qualifiers)"
CALL :run IDE0004 "Remove unnecessary cast"

:: IDE0005 Doesn't Handle Interops very well
:: CALL :run IDE0005 "Remove unnecessary using / Imports directives"
:: CALL :run IDE0035 "Remove unreachable code"
CALL :run IDE0051 "Remove unused private members (fields, methods, etc.)"
:: CALL :run IDE0052 "Remove unread private members"
CALL :run IDE0058 "Remove unnecessary expression value"
CALL :run IDE0059 "Remove unnecessary value assignment"
CALL :run IDE0060 "Remove unused parameters"
CALL :run IDE0079 "Remove unnecessary suppression (#pragma warning / SuppressMessage)"
:: CALL :run IDE0100 "Remove redundant equality comparison (x == true → x)"
CALL :run IDE0110 "Remove unnecessary discard"

:: --- this. / Me. Qualification ---
CALL :run IDE0003 "Remove 'this.' / 'Me.' qualification (when not required)"
:: CALL :run IDE0009 "Add 'this.' / 'Me.' qualification (when required by config)"

:: --- var / Explicit Type ---
:: CALL :run IDE0007 "Use 'var' instead of explicit type (when apparent)"
CALL :run IDE0008 "Use explicit type instead of 'var' (when preferred by config)"

:: --- Expression Bodies ---
CALL :run IDE0021 "Use expression body for constructors"
CALL :run IDE0022 "Use expression body for methods"
CALL :run IDE0023 "Use expression body for conversion operators"
CALL :run IDE0024 "Use expression body for operators"
CALL :run IDE0025 "Use expression body for properties"
CALL :run IDE0026 "Use expression body for indexers"
CALL :run IDE0027 "Use expression body for accessors"
CALL :run IDE0053 "Use expression body for lambdas"
CALL :run IDE0061 "Use expression body for local functions"

:: --- Braces ---
CALL :run IDE0011 "Add braces to control-flow statements (if, else, for, etc.)"

:: --- Object / Collection Initializers ---
:: CALL :run IDE0017 "Simplify object initialization (use object initializers)"
CALL :run IDE0028 "Simplify collection initialization (use collection initializers)"
CALL :run IDE0300 "Use collection expression for array"
CALL :run IDE0301 "Use collection expression for empty"
CALL :run IDE0302 "Use collection expression for stackalloc"
CALL :run IDE0303 "Use collection expression for Create()"
CALL :run IDE0304 "Use collection expression for builder"
CALL :run IDE0305 "Use collection expression for fluent"

:: --- Null Checks & Coalescing ---
CALL :run IDE0016 "Use throw expression"
CALL :run IDE0029 "Null check can be simplified (use ?. operator)"
CALL :run IDE0030 "Null check can be simplified (use ?? operator)"
CALL :run IDE0031 "Use null propagation"
CALL :run IDE0041 "Use is null check instead of object.ReferenceEquals"
CALL :run IDE0150 "Prefer 'null' check over type check"

:: --- Pattern Matching ---
CALL :run IDE0019 "Use pattern matching (as + null check → is pattern)"
CALL :run IDE0020 "Use pattern matching (is + cast)"
CALL :run IDE0038 "Use pattern matching to avoid 'is' check followed by a cast"
CALL :run IDE0170 "Simplify property pattern"
CALL :run IDE0260 "Use pattern matching"

:: --- Conditional / Switch Expressions ---
CALL :run IDE0045 "Use conditional expression for assignment"
CALL :run IDE0046 "Use conditional expression for return"
CALL :run IDE0066 "Use switch expression"
CALL :run IDE0072 "Add missing cases to switch expression"
CALL :run IDE0010 "Add missing cases to switch statement"

:: --- Auto-Properties & Readonly ---
CALL :run IDE0032 "Use auto-implemented property"
CALL :run IDE0044 "Add readonly modifier to private fields that are never modified"

:: --- Modern C# Syntax ---
CALL :run IDE0018 "Inline variable declaration (out var)"
CALL :run IDE0034 "Simplify default expression (default(T) → default)"
CALL :run IDE0036 "Order modifiers (public static → follows configured order)"
CALL :run IDE0039 "Use local function instead of lambda"
CALL :run IDE0042 "Deconstruct variable declaration"
CALL :run IDE0054 "Use compound assignment (x = x + 1 → x += 1)"
CALL :run IDE0056 "Use index operator (^1)"
CALL :run IDE0057 "Use range operator (..)"
CALL :run IDE0062 "Make local function static"
CALL :run IDE0063 "Use simple 'using' statement (using var x = …)"
CALL :run IDE0064 "Make struct fields writable"
CALL :run IDE0074 "Use coalesce compound assignment (??=)"
CALL :run IDE0078 "Use pattern matching (replace && with and)"
CALL :run IDE0083 "Use pattern matching (not operator)"
CALL :run IDE0090 "Simplify new expression (new() instead of new T())"
CALL :run IDE0160 "Use block-scoped namespace"
CALL :run IDE0161 "Use file-scoped namespace declaration"
CALL :run IDE0200 "Remove unnecessary lambda expression"
CALL :run IDE0210 "Convert to top-level statements"
CALL :run IDE0230 "Use UTF-8 string literal"
CALL :run IDE0250 "Make struct 'readonly'"
CALL :run IDE0251 "Make member 'readonly'"
CALL :run IDE0290 "Use primary constructor"
CALL :run IDE0330 "Prefer 'System.Threading.Lock'"

:: --- Formatting ---
CALL :run IDE0055 "Fix formatting (indentation, spacing, line breaks per .editorconfig)"
CALL :run IDE2000 "Allow / disallow multiple blank lines"
CALL :run IDE2001 "Embedded statements must not be on same line"
CALL :run IDE2002 "Consecutive braces must not be on same line"
CALL :run IDE2003 "Allow / disallow blank line after colon in constructor initializer"
CALL :run IDE2004 "Blank line required after switch section (when configured)"
CALL :run IDE2005 "Blank line between using directive groups"
CALL :run IDE2006 "Blank line before using directive group"

:: --- Using Directives Placement ---
CALL :run IDE0065 "'using' directive placement (inside vs outside namespace)"

ECHO.
ECHO ===========================================================================
ECHO SECTION 3 — SA STYLECOP RULES (StyleCop.Analyzers NuGet package required)
ECHO Add <PackageReference Include="StyleCop.Analyzers" Version="1.2.*" /> to
ECHO your project, then CALL :run dotnet restore before using these.
ECHO ===========================================================================

:: --- Spacing Rules (SA1000–SA1029) ---
CALL :run SA1000 "Keywords must be spaced correctly"
CALL :run SA1001 "Commas must be spaced correctly"
CALL :run SA1002 "Semicolons must be spaced correctly"
CALL :run SA1003 "Symbols must be spaced correctly"
CALL :run SA1004 "Documentation lines must begin with single space"
CALL :run SA1005 "Single-line comment must begin with a space"
CALL :run SA1006 "Preprocessor keywords must not be preceded by space"
CALL :run SA1007 "Operator keyword must be followed by space"
CALL :run SA1008 "Opening parenthesis must not be preceded by space"
CALL :run SA1009 "Closing parenthesis must be spaced correctly"
CALL :run SA1010 "Opening square bracket must not be preceded by space"
CALL :run SA1011 "Closing square bracket must be spaced correctly"
CALL :run SA1012 "Opening brace must be preceded by space"
CALL :run SA1013 "Closing brace must be preceded by space"
CALL :run SA1014 "Opening generic bracket must not be preceded by space"
CALL :run SA1015 "Closing generic bracket must be spaced correctly"
CALL :run SA1016 "Opening attribute bracket must not be preceded by space"
CALL :run SA1017 "Closing attribute bracket must not be preceded by space"
CALL :run SA1018 "Nullable type symbol must not be preceded by space"
CALL :run SA1019 "Member access symbol must be spaced correctly"
CALL :run SA1020 "Increment / decrement symbols must be spaced correctly"
CALL :run SA1021 "Negative sign must be spaced correctly"
CALL :run SA1022 "Positive sign must be spaced correctly"
CALL :run SA1023 "Dereference and access-of symbol must be spaced correctly"
CALL :run SA1024 "Colon must be spaced correctly"
CALL :run SA1025 "Code must not contain multiple whitespace in a row"
CALL :run SA1026 "Code must not contain space after new keyword in implicit allocation"
CALL :run SA1027 "Use tabs correctly"
CALL :run SA1028 "Code should not contain trailing whitespace"

:: --- Readability Rules (SA1100-SA1150) ---
CALL :run SA1100 "Do not prefix CALLs with base unless local implementation exists"
CALL :run SA1101 "Prefix local CALLs with this"
CALL :run SA1106 "Code must not contain empty statements"
CALL :run SA1107 "Code must not contain multiple statements on one line"
CALL :run SA1110 "Opening parenthesis must be on declaration line"
CALL :run SA1111 "Closing parenthesis must be on line of last parameter"
CALL :run SA1112 "Closing parenthesis must be on line of opening parenthesis"
CALL :run SA1113 "Comma must be on same line as previous parameter"
CALL :run SA1116 "Split parameters must start on line after declaration"
CALL :run SA1119 "Statement must not use unnecessary parenthesis"
CALL :run SA1120 "Comments must contain text"
CALL :run SA1121 "Use built-in type alias (String -> string, Int32 -> int)"
CALL :run SA1122 "Use string.Empty for empty strings"
CALL :run SA1123 "Do not place regions within elements"
CALL :run SA1124 "Do not use regions"
CALL :run SA1125 "Use shorthand for nullable types (Nullable<T> -> T?)"
CALL :run SA1127 "Generic type constraints must be on their own line"
CALL :run SA1128 "Put constructor initializers on their own line"
CALL :run SA1129 "Do not use default value-type constructor"
CALL :run SA1130 "Use lambda syntax"
CALL :run SA1131 "Use readable conditions (constants on right side)"
CALL :run SA1132 "Do not combine fields"
CALL :run SA1133 "Do not combine attributes"
CALL :run SA1134 "Attributes must not share line"
CALL :run SA1135 "Using directives must be qualified"
CALL :run SA1136 "Enum values must be on separate lines"
CALL :run SA1137 "Elements must have same indentation"
CALL :run SA1139 "Use literal suffix notation instead of casting"

:: --- Ordering Rules (SA1200-SA1217) ---
CALL :run SA1200 "Using directives must be placed correctly"
CALL :run SA1205 "Partial elements must declare access"
CALL :run SA1207 "Protected must come before internal"
CALL :run SA1208 "System using directives must be placed before other using directives"
CALL :run SA1209 "Using alias directives must be placed after other using directives"
CALL :run SA1210 "Using directives must be ordered alphabetiCALLy by namespace"
CALL :run SA1211 "Using alias directives must be ordered alphabetiCALLy"
CALL :run SA1212 "Property accessors must follow order"
CALL :run SA1213 "Event accessors must follow order"
CALL :run SA1216 "Using static directives must be placed at correct location"
CALL :run SA1217 "Using static directives must be ordered alphabetiCALLy"

:: --- Naming Rules (SA1300-SA1316) ---
CALL :run SA1300 "Element must begin with upper-case letter"
CALL :run SA1302 "Interface names must begin with I"
CALL :run SA1303 "Const field names must begin with upper-case letter"
CALL :run SA1304 "Non-private readonly fields must begin with upper-case letter"
CALL :run SA1306 "Field names must begin with lower-case letter"
CALL :run SA1307 "Accessible fields must begin with upper-case letter"
CALL :run SA1308 "Variable names must not be prefixed"
CALL :run SA1309 "Field names must not begin with underscore"
CALL :run SA1310 "Field names must not contain underscore"
CALL :run SA1311 "Static readonly fields must begin with upper-case letter"
CALL :run SA1312 "Variable names must begin with lower-case letter"
CALL :run SA1313 "Parameter names must begin with lower-case letter"
CALL :run SA1314 "Type parameter names must begin with T"
CALL :run SA1316 "Tuple element names must use correct casing"

:: --- Maintainability Rules (SA1400-SA1413) ---
CALL :run SA1400 "Access modifier must be declared"
CALL :run SA1402 "File may only contain a single type"
CALL :run SA1407 "Arithmetic expressions must declare precedence"
CALL :run SA1408 "Conditional expressions must declare precedence"
CALL :run SA1410 "Remove delegate parenthesis when possible"
CALL :run SA1411 "Attribute constructor must not use unnecessary parenthesis"
CALL :run SA1412 "Store files as UTF-8 with byte order mark"
CALL :run SA1413 "Use trailing comma in multi-line initializers"

:: --- Layout Rules (SA1500-SA1520) ---
CALL :run SA1500 "Braces for multi-line statements must not share line"
CALL :run SA1501 "Statement must not be on single line"
CALL :run SA1502 "Element must not be on single line"
CALL :run SA1503 "Braces must not be omitted"
CALL :run SA1504 "All accessors must be single-line or multi-line"
CALL :run SA1505 "Opening brace must not be followed by blank line"
CALL :run SA1506 "Element documentation headers must not be followed by blank line"
CALL :run SA1507 "Code must not contain multiple blank lines in a row"
CALL :run SA1508 "Closing brace must not be preceded by blank line"
CALL :run SA1509 "Opening brace must not be preceded by blank line"
CALL :run SA1510 "Chained statement blocks must not be preceded by blank line"
CALL :run SA1511 "While-do footer must not be preceded by blank line"
CALL :run SA1512 "Single-line comments must not be followed by blank line"
CALL :run SA1513 "Closing brace must be followed by blank line"
CALL :run SA1514 "Element documentation header must be preceded by blank line"
CALL :run SA1515 "Single-line comment must be preceded by blank line"
CALL :run SA1516 "Elements must be separated by blank line"
CALL :run SA1517 "Code must not contain blank lines at start of file"
CALL :run SA1518 "Use line endings correctly at end of file"
CALL :run SA1519 "Braces must not be omitted from multi-line child statement"
CALL :run SA1520 "Use braces consistently"

:: --- Selected documentation/file-header rules with real fixes ---
CALL :run SA1626 "Single-line comments must not use documentation-style slashes"
CALL :run SA1633 "File must have header (inserts a stub - configure stylecop.json for real content)"

IF EXIST "%progressFile%" DEL /Q "%progressFile%"

ENDLOCAL
GOTO :EOF

:: :run subroutine
:: %1 = diagnostic id, %2 = description (quoted)
:run
IF EXIST "%progressFile%" (
	findstr /x /c:"%~1" "%progressFile%" >nul 2>&1
	IF NOT ERRORLEVEL 1 GOTO :eof
)

ECHO.
ECHO [%~1] %~2

dotnet format "%location%" --diagnostics %~1 --verbosity detailed | %filterCommand%

ECHO %~1>>"%progressFile%"

ECHO [%~1] %~2 Completed

PAUSE
GOTO :EOF

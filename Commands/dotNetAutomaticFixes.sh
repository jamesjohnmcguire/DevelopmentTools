#!/bin/bash
#!/usr/bin/env bash

# =============================================================================
# dotnet format - Comprehensive Auto-Fixable Diagnostics Script
# =============================================================================
# Run each block independently or comment out sections you don't need.
# Requires: .NET 6+ SDK (dotnet format is built-in)
# Requires: StyleCop.Analyzers NuGet package for SA* rules
#
# Usage: ./dotNetAutomaticFixes.sh [path/to/solution.sln] [--reset]
#
#   path/to/solution.sln   Optional. Defaults to "." (current directory).
#   --reset                Clear saved progress and start from rule #1,
#                          without the interactive resume prompt.
#
# RESUME SUPPORT
# ------------------------------------------------------------------
# Progress is written to a small text file (one completed diagnostic ID
# per line) next to your target: <target>/.dotnet-format-progress
#
# Ctrl-C at any point is safe. Come back later and re-run this script from
# the same directory. It skips everything already marked done, and picks up on
# the next not run rule automatically.
# =============================================================================

is_done()
{
	[[ -f "$progressFile" ]] && grep -qxF "$1" "$progressFile"
}

run()
{
	local id="$1"
	local desc="$2"

	if is_done "$id"; then
		return
	fi

	echo ""
	echo "[$id] $desc"

	dotnet format "$location" --diagnostics "$id" --verbosity detailed | grep -v "is using configuration from"

	echo "$id" >> "$progressFile"

	echo "[$id] $desc Completed"
	read -r -p "  >> Press any key to continue..." -n 1
}

location=.
reset=false

if [ $# -gt 0 ]; then
	if [ "$1" != "--reset" ]; then
		location="$1"
	elif [ "$1" == "--reset" ]; then
		reset=true
	fi

	if [ $# -gt 1 ]; then
		echo "arg2 $2"
		if [ "$2" == "--reset" ]; then
			reset=true
		fi
	fi
fi

progressFile="${location%/}/.dotnet-fixes"

if [[ "$reset" == true ]]; then
	rm -f "$progressFile"
fi

echo ""
echo "============================================================================="
echo "CA CODE QUALITY RULES (Microsoft.CodeAnalysis.NetAnalyzers)"
echo "============================================================================="

# --- Style / Maintainability ---
run "CA1052" "Type is a static holder type but is neither static nor NotInheritable"
run "CA1507" "Use nameof instead of hardcoded string literal for member name"
run "CA1510" "Use ArgumentNullException throw helper"
run "CA1511" "Use ArgumentException throw helper"
run "CA1512" "Use ArgumentOutOfRangeException throw helper"
run "CA1513" "Use ObjectDisposedException throw helper"
run "CA1515" "Types can be made internal"
run "CA2208" "Instantiate argument exceptions correctly"
run "CA2211" "Non-constant fields should not be visible (make const or readonly)"
run "CA2245" "Do not assign a property to itself"
run "CA2249" "Consider using String.Contains instead of String.IndexOf"

run "CA1815" "???"

# --- Performance ---
run "CA1802" "Use literals where appropriate (static readonly → const)"
run "CA1805" "Do not initialize unnecessarily (default value assignments)"
run "CA1812" "Avoid uninstantiated internal classes"
run "CA1823" "Remove unused private fields"
run "CA1825" "Avoid zero-length array allocations (use Array.Empty<T>())"
run "CA1826" "Do not use Enumerable methods on indexable collections (use indexer)"
run "CA1827" "Do not use Count()/LongCount() when Any() can be used"
run "CA1828" "Do not use CountAsync/LongCountAsync when AnyAsync can be used"
run "CA1829" "Use Length/Count instead of Enumerable.Count()"
run "CA1830" "Prefer strongly-typed StringBuilder.Append overloads"
run "CA1831" "Use AsSpan instead of Range-based indexer for string"
run "CA1832" "Use AsSpan instead of Range-based indexer for array"
run "CA1833" "Use AsSpan instead of Range-based indexer (Memory overload)"
run "CA1834" "Use StringBuilder.Append(char) for single-character strings"
run "CA1835" "Prefer the 'Memory'-based overloads for ReadAsync/WriteAsync"
run "CA1836" "Prefer IsEmpty over Count"
run "CA1837" "Use Environment.ProcessId instead of Process.GetCurrentProcess().Id"
run "CA1838" "Avoid StringBuilder parameters for P/Invokes"
run "CA1841" "Prefer Dictionary.Contains methods"
run "CA1845" "Use span-based string.Concat and AsSpan instead of Substring"
run "CA1846" "Prefer AsSpan over Substring when span-based overloads are available"
run "CA1847" "Use string.Contains(char) instead of string.Contains(string)"
run "CA1852" "Seal internal types"
run "CA1854" "Prefer Dictionary.TryGetValue"
run "CA1855" "Prefer Clear() over Fill() to clear spans"
run "CA1860" "Avoid using Enumerable.Any() — use Length, Count, or IsEmpty"
run "CA1861" "Avoid constant arrays as arguments"
run "CA1862" "Use StringComparison.OrdinalIgnoreCase overloads"
run "CA1863" "Use CompositeFormat"
run "CA1864" "Prefer the IDictionary.TryAdd(key, value) method"
run "CA1865" "Use string.Method(char) instead of string.Method(string)"
run "CA1868" "Unnecessary call to Contains for sets"
run "CA1869" "Cache and reuse JsonSerializerOptions"

# --- Reliability ---
run "CA2016" "Forward the CancellationToken parameter to methods that take one"


echo ""
echo "============================================================================="
echo "IDE STYLE RULES (Roslyn / Microsoft.CodeAnalysis)"
echo "These are part of the built-in .NET SDK analyzers."
echo "============================================================================="

# --- Simplification & Unnecessary Code ---
run "IDE0001" "Simplify type name (e.g. System.IO.FileInfo → FileInfo)"
run "IDE0002" "Simplify member access (e.g. remove redundant qualifiers)"
run "IDE0004" "Remove unnecessary cast"

# IDE0005 Doesn't Handle Interops very well
# run "IDE0005" "Remove unnecessary using / Imports directives"
# run "IDE0035" "Remove unreachable code"
run "IDE0051" "Remove unused private members (fields, methods, etc.)"
# run "IDE0052" "Remove unread private members"
run "IDE0058" "Remove unnecessary expression value"
run "IDE0059" "Remove unnecessary value assignment"
run "IDE0060" "Remove unused parameters"
run "IDE0079" "Remove unnecessary suppression (#pragma warning / SuppressMessage)"
# run "IDE0100" "Remove redundant equality comparison (x == true → x)"
run "IDE0110" "Remove unnecessary discard"

# --- this. / Me. Qualification ---
run "IDE0003" "Remove 'this.' / 'Me.' qualification (when not required)"
# run "IDE0009" "Add 'this.' / 'Me.' qualification (when required by config)"

# --- var / Explicit Type ---
# run "IDE0007" "Use 'var' instead of explicit type (when apparent)"
run "IDE0008" "Use explicit type instead of 'var' (when preferred by config)"

# --- Expression Bodies ---
run "IDE0021" "Use expression body for constructors"
run "IDE0022" "Use expression body for methods"
run "IDE0023" "Use expression body for conversion operators"
run "IDE0024" "Use expression body for operators"
run "IDE0025" "Use expression body for properties"
run "IDE0026" "Use expression body for indexers"
run "IDE0027" "Use expression body for accessors"
run "IDE0053" "Use expression body for lambdas"
run "IDE0061" "Use expression body for local functions"

# --- Braces ---
run "IDE0011" "Add braces to control-flow statements (if, else, for, etc.)"

# --- Object / Collection Initializers ---
# run "IDE0017" "Simplify object initialization (use object initializers)"
run "IDE0028" "Simplify collection initialization (use collection initializers)"
run "IDE0300" "Use collection expression for array"
run "IDE0301" "Use collection expression for empty"
run "IDE0302" "Use collection expression for stackalloc"
run "IDE0303" "Use collection expression for Create()"
run "IDE0304" "Use collection expression for builder"
run "IDE0305" "Use collection expression for fluent"

# --- Null Checks & Coalescing ---
run "IDE0016" "Use throw expression"
run "IDE0029" "Null check can be simplified (use ?. operator)"
run "IDE0030" "Null check can be simplified (use ?? operator)"
run "IDE0031" "Use null propagation"
run "IDE0041" "Use is null check instead of object.ReferenceEquals"
run "IDE0150" "Prefer 'null' check over type check"

# --- Pattern Matching ---
run "IDE0019" "Use pattern matching (as + null check → is pattern)"
run "IDE0020" "Use pattern matching (is + cast)"
run "IDE0038" "Use pattern matching to avoid 'is' check followed by a cast"
run "IDE0170" "Simplify property pattern"
run "IDE0260" "Use pattern matching"

# --- Conditional / Switch Expressions ---
run "IDE0045" "Use conditional expression for assignment"
run "IDE0046" "Use conditional expression for return"
run "IDE0066" "Use switch expression"
run "IDE0072" "Add missing cases to switch expression"
run "IDE0010" "Add missing cases to switch statement"

# --- Auto-Properties & Readonly ---
run "IDE0032" "Use auto-implemented property"
run "IDE0044" "Add readonly modifier to private fields that are never modified"

# --- Modern C# Syntax ---
run "IDE0018" "Inline variable declaration (out var)"
run "IDE0034" "Simplify default expression (default(T) → default)"
run "IDE0036" "Order modifiers (public static → follows configured order)"
run "IDE0039" "Use local function instead of lambda"
run "IDE0042" "Deconstruct variable declaration"
run "IDE0054" "Use compound assignment (x = x + 1 → x += 1)"
run "IDE0056" "Use index operator (^1)"
run "IDE0057" "Use range operator (..)"
run "IDE0062" "Make local function static"
run "IDE0063" "Use simple 'using' statement (using var x = …)"
run "IDE0064" "Make struct fields writable"
run "IDE0074" "Use coalesce compound assignment (??=)"
run "IDE0078" "Use pattern matching (replace && with and)"
run "IDE0083" "Use pattern matching (not operator)"
run "IDE0090" "Simplify new expression (new() instead of new T())"
run "IDE0160" "Use block-scoped namespace"
run "IDE0161" "Use file-scoped namespace declaration"
run "IDE0200" "Remove unnecessary lambda expression"
run "IDE0210" "Convert to top-level statements"
run "IDE0230" "Use UTF-8 string literal"
run "IDE0250" "Make struct 'readonly'"
run "IDE0251" "Make member 'readonly'"
run "IDE0290" "Use primary constructor"
run "IDE0330" "Prefer 'System.Threading.Lock'"

# --- Formatting ---
run "IDE0055" "Fix formatting (indentation, spacing, line breaks per .editorconfig)"
run "IDE2000" "Allow / disallow multiple blank lines"
run "IDE2001" "Embedded statements must not be on same line"
run "IDE2002" "Consecutive braces must not be on same line"
run "IDE2003" "Allow / disallow blank line after colon in constructor initializer"
run "IDE2004" "Blank line required after switch section (when configured)"
run "IDE2005" "Blank line between using directive groups"
run "IDE2006" "Blank line before using directive group"

# --- Using Directives Placement ---
run "IDE0065" "'using' directive placement (inside vs outside namespace)"

echo ""
echo "============================================================================="
echo "SECTION 3 — SA STYLECOP RULES (StyleCop.Analyzers NuGet package required)"
echo "Add <PackageReference Include="StyleCop.Analyzers" Version="1.2.*" /> to"
echo "your project, then run dotnet restore before using these."
echo "============================================================================="

# --- Spacing Rules (SA1000–SA1029) ---
run "SA1000" "Keywords must be spaced correctly"
run "SA1001" "Commas must be spaced correctly"
run "SA1002" "Semicolons must be spaced correctly"
run "SA1003" "Symbols must be spaced correctly"
run "SA1004" "Documentation lines must begin with single space"
run "SA1005" "Single-line comment must begin with a space"
run "SA1006" "Preprocessor keywords must not be preceded by space"
run "SA1007" "Operator keyword must be followed by space"
run "SA1008" "Opening parenthesis must not be preceded by space"
run "SA1009" "Closing parenthesis must be spaced correctly"
run "SA1010" "Opening square bracket must not be preceded by space"
run "SA1011" "Closing square bracket must be spaced correctly"
run "SA1012" "Opening brace must be preceded by space"
run "SA1013" "Closing brace must be preceded by space"
run "SA1014" "Opening generic bracket must not be preceded by space"
run "SA1015" "Closing generic bracket must be spaced correctly"
run "SA1016" "Opening attribute bracket must not be preceded by space"
run "SA1017" "Closing attribute bracket must not be preceded by space"
run "SA1018" "Nullable type symbol must not be preceded by space"
run "SA1019" "Member access symbol must be spaced correctly"
run "SA1020" "Increment / decrement symbols must be spaced correctly"
run "SA1021" "Negative sign must be spaced correctly"
run "SA1022" "Positive sign must be spaced correctly"
run "SA1023" "Dereference and access-of symbol must be spaced correctly"
run "SA1024" "Colon must be spaced correctly"
run "SA1025" "Code must not contain multiple whitespace in a row"
run "SA1026" "Code must not contain space after new keyword in implicit allocation"
run "SA1027" "Use tabs correctly"
run "SA1028" "Code should not contain trailing whitespace"

# --- Readability Rules (SA1100-SA1150) ---
run "SA1100" "Do not prefix calls with base unless local implementation exists"
run "SA1101" "Prefix local calls with this"
run "SA1106" "Code must not contain empty statements"
run "SA1107" "Code must not contain multiple statements on one line"
run "SA1110" "Opening parenthesis must be on declaration line"
run "SA1111" "Closing parenthesis must be on line of last parameter"
run "SA1112" "Closing parenthesis must be on line of opening parenthesis"
run "SA1113" "Comma must be on same line as previous parameter"
run "SA1116" "Split parameters must start on line after declaration"
run "SA1119" "Statement must not use unnecessary parenthesis"
run "SA1120" "Comments must contain text"
run "SA1121" "Use built-in type alias (String -> string, Int32 -> int)"
run "SA1122" "Use string.Empty for empty strings"
run "SA1123" "Do not place regions within elements"
run "SA1124" "Do not use regions"
run "SA1125" "Use shorthand for nullable types (Nullable<T> -> T?)"
run "SA1127" "Generic type constraints must be on their own line"
run "SA1128" "Put constructor initializers on their own line"
run "SA1129" "Do not use default value-type constructor"
run "SA1130" "Use lambda syntax"
run "SA1131" "Use readable conditions (constants on right side)"
run "SA1132" "Do not combine fields"
run "SA1133" "Do not combine attributes"
run "SA1134" "Attributes must not share line"
run "SA1135" "Using directives must be qualified"
run "SA1136" "Enum values must be on separate lines"
run "SA1137" "Elements must have same indentation"
run "SA1139" "Use literal suffix notation instead of casting"

# --- Ordering Rules (SA1200-SA1217) ---
run "SA1200" "Using directives must be placed correctly"
run "SA1205" "Partial elements must declare access"
run "SA1207" "Protected must come before internal"
run "SA1208" "System using directives must be placed before other using directives"
run "SA1209" "Using alias directives must be placed after other using directives"
run "SA1210" "Using directives must be ordered alphabetically by namespace"
run "SA1211" "Using alias directives must be ordered alphabetically"
run "SA1212" "Property accessors must follow order"
run "SA1213" "Event accessors must follow order"
run "SA1216" "Using static directives must be placed at correct location"
run "SA1217" "Using static directives must be ordered alphabetically"

# --- Naming Rules (SA1300-SA1316) ---
run "SA1300" "Element must begin with upper-case letter"
run "SA1301" "Element must begin with lower-case letter"
run "SA1302" "Interface names must begin with I"
run "SA1303" "Const field names must begin with upper-case letter"
run "SA1304" "Non-private readonly fields must begin with upper-case letter"
run "SA1306" "Field names must begin with lower-case letter"
run "SA1307" "Accessible fields must begin with upper-case letter"
run "SA1308" "Variable names must not be prefixed"
run "SA1309" "Field names must not begin with underscore"
run "SA1310" "Field names must not contain underscore"
run "SA1311" "Static readonly fields must begin with upper-case letter"
run "SA1312" "Variable names must begin with lower-case letter"
run "SA1313" "Parameter names must begin with lower-case letter"
run "SA1314" "Type parameter names must begin with T"
run "SA1316" "Tuple element names must use correct casing"

# --- Maintainability Rules (SA1400-SA1413) ---
run "SA1400" "Access modifier must be declared"
run "SA1402" "File may only contain a single type"
run "SA1407" "Arithmetic expressions must declare precedence"
run "SA1408" "Conditional expressions must declare precedence"
run "SA1410" "Remove delegate parenthesis when possible"
run "SA1411" "Attribute constructor must not use unnecessary parenthesis"
run "SA1412" "Store files as UTF-8 with byte order mark"
run "SA1413" "Use trailing comma in multi-line initializers"

# --- Layout Rules (SA1500-SA1520) ---
run "SA1500" "Braces for multi-line statements must not share line"
run "SA1501" "Statement must not be on single line"
run "SA1502" "Element must not be on single line"
run "SA1503" "Braces must not be omitted"
run "SA1504" "All accessors must be single-line or multi-line"
run "SA1505" "Opening brace must not be followed by blank line"
run "SA1506" "Element documentation headers must not be followed by blank line"
run "SA1507" "Code must not contain multiple blank lines in a row"
run "SA1508" "Closing brace must not be preceded by blank line"
run "SA1509" "Opening brace must not be preceded by blank line"
run "SA1510" "Chained statement blocks must not be preceded by blank line"
run "SA1511" "While-do footer must not be preceded by blank line"
run "SA1512" "Single-line comments must not be followed by blank line"
run "SA1513" "Closing brace must be followed by blank line"
run "SA1514" "Element documentation header must be preceded by blank line"
run "SA1515" "Single-line comment must be preceded by blank line"
run "SA1516" "Elements must be separated by blank line"
run "SA1517" "Code must not contain blank lines at start of file"
run "SA1518" "Use line endings correctly at end of file"
run "SA1519" "Braces must not be omitted from multi-line child statement"
run "SA1520" "Use braces consistently"

run "SA1626" "Single-line comments must not use documentation-style slashes"
run "SA1638" "Each Attribute Should Be on It's Own Line"

rm -f "$progressFile"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅  All auto-fixable diagnostics processed."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  TIP: To run ALL rules in one shot (no pauses), use:"
echo "    dotnet format \$location --severity info --verbosity detailed"
echo ""

for %%f in ("%1") do set FileName=%%~nf

7z x %1 -r -o%FileName%

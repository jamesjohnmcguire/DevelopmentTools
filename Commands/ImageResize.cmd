REM ImageResize <type> <input file> <output> <width (or height)>
if "%1" == "optimize" goto optimize
if "%1" == "height" goto height
goto normal

:optimize
magick.exe convert %2 -filter Triangle -define filter:support=2 -thumbnail %4 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -sampling-factor 4:2:0 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB %3
goto end

:height
CALL magick.exe convert %2 -resize x%4 %3
goto end

:normal
CALL magick.exe convert %2 -resize %4x%4 %3
:end

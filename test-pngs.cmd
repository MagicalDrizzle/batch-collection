@echo off
if not exist test.png (echo test.png not found & goto end)
if exist test_ect.png (goto aftercopy) else (
copy test.png test_ect.png
copy test.png test_oxipng.png
copy test.png test_pingo.png
copy test.png test_cl.png
copy test.png test_pngout.png
copy test.png test_truepng.png
REM shitty
copy test.png test_advdef.png
copy test.png test_advpng.png
copy test.png test_optipng.png
copy test.png test_pngcrush.png
)
for %%I in (test.png) do set size=%%~zI
goto testfiles
:testfiles
start "ect -9 -strip test_ect.png" ect -9 -strip test_ect.png 
start "oxipng -s -o max test_oxipng.png" oxipng -s -o max test_oxipng.png 
start "pingo -s4 -lossless test_pingo.png" pingo -s4 -lossless test_pingo.png 
start "pngoptimizercl test_cl.png" pngoptimizercl test_cl.png 
start "pngout /b512 test_pngout.png" pngout /b512 test_pngout.png 
start "truepng /o max test_truepng.png" truepng /o max test_truepng.png 
REM shitty
start "optipng -zc8-9 -zm8-9 -zs0-3 -f0-5 -clobber test_optipng.png" optipng -zc8-9 -zm8-9 -zs0-3 -f0-5 -clobber test_optipng.png 
start "pngcrush -brute -new -ow test_pngcrush.png" pngcrush -brute -new -ow test_pngcrush.png 
start "advdef -z -4 test_advdef.png" advdef -z -4 test_advdef.png 
start "advpng -z -4 -i 3 test_advpng.png" advpng -z -4 -i 3 test_advpng.png
goto list
:aftercopy
echo files already copied
goto testfiles
:list
tasklist | findstr /I /c:ect.exe /c:oxipng.exe /c:pingo.exe /c:pngoptimizercl.exe ^
/c:pngout.exe /c:truepng.exe /c:optipng.exe /c:pngcrush.exe /c:advdef.exe /c:advpng.exe > nul
if %errorlevel%==0 (
	timeout /t 5 /nobreak
	goto list
) else (
	if %size% LSS 200000 ( 
		busybox du -b *.png | busybox sort -n
		goto end 
	) else (
		busybox du -k *.png | busybox sort -n
		goto end
	)
)
:end
echo done
pause
@echo off
setlocal
ver >nul
echo Choose the file that you want to filter out domains:
:input
set "_inputfile="
set /P _inputfile="> "
if not exist %_inputfile% (
    echo File not found^! Choose again:
    goto input
)
echo %_inputfile% | findstr /R \^".*\^" >nul 2>&1
if %errorlevel% equ 0 set _inputfile=%_inputfile:"='%
:output
echo Choose output file ^(default: result.txt^)
set "_outputfile="
set /P _outputfile="> "
if not defined _outputfile set _outputfile=result.txt
setlocal enabledelayedexpansion
if exist %_outputfile% (
    echo Do you wish to overwrite %_outputfile%? ^(y/N^)
    set /P _overwrite="> "
    if [!_overwrite!] == [Y] (
        goto yes
    ) else if [!_overwrite!] == [y] (
        goto yes
    ) else (
        goto output
    )
)
:yes
endlocal
echo %_outputfile% | findstr /R \^".*\^" >nul 2>&1
if %errorlevel% equ 0 set _outputfile=%_outputfile:"='%
echo -- %_inputfile:'=% > %_outputfile:'="%
busybox sh -c "findstr /C:0.0.0.0 /C:127.0.0.1 %_inputfile% | sed 's/0.0.0.0 \|127.0.0.1 //' >> %_outputfile% && dos2unix %_outputfile%"
echo done.
endlocal
pause

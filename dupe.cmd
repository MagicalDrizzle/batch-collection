@echo off
setlocal
ver >nul
echo Choose the file that you want to see unique lines of:
:1st
set "_firstfile="
set /P _firstfile="> "
if not exist %_firstfile% (
    echo File not found^! Choose again:
	goto 1st
)
echo %_firstfile% | findstr /R \^".*\^" >nul 2>&1
if %errorlevel% equ 0 set _firstfile=%_firstfile:"='%
echo Choose the file that has the duplicate lines:
:2nd
set "_secondfile="
set /P _secondfile="> "
if not exist %_secondfile% (
    echo File not found^! Choose again:
	goto 2nd
)
echo %_secondfile% | findstr /R \^".*\^" >nul 2>&1
if %errorlevel% equ 0 set _secondfile=%_secondfile:"='%
:output
echo Choose output file ^(default: result.txt^)
set "_outputfile="
set /P _outputfile="> "
if not defined _outputfile set _outputfile=result.txt
setlocal enabledelayedexpansion
if exist %_outputfile% (
    echo Do you wish to overwrite %_outputfile%? ^(y/N^)
    set /P _overwrite="> "
    if [!_overwrite!] equ [Y] (
        goto yes
    ) else if [!_overwrite!] equ [y] (
        goto yes
    ) else (
        goto output
    )
)
:yes
endlocal
echo %_outputfile% | findstr /R \^".*\^" >nul 2>&1
if %errorlevel% equ 0 set _outputfile=%_outputfile:"='%
echo -- %_firstfile:'=% > %_outputfile:'="%
busybox sh -c "diff <(sort -u %_firstfile%) <(sort -u %_secondfile%) | sed -n 's/^-//p' | sed '/-- \/dev\/fd\/[0-9][0-9]/d' | sort -u >> %_outputfile% && dos2unix %_outputfile%"
echo done.
endlocal
pause

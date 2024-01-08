@echo off
setlocal
:start
echo Select channel:
echo [1] Release
echo [2] Beta (default)
echo [3] Nightly
set /P _inputname="> "
if not defined _inputname set _inputname=2
echo.
IF "%_inputname%"=="1" goto :Release
IF "%_inputname%"=="2" goto :Beta
IF "%_inputname%"=="3" goto :Nightly
echo.
echo I couldn't understand you, pick one of the options
goto :start

:Release
busybox wget https://brave-browser-downloads.s3.brave.com/latest/brave_installer-x64.exe -O brave_installer-x64.exe
7z x -aoa brave_installer-x64.exe 
7z x -aoa chrome.7z
rename Chrome-bin app
rmdir /S /Q ..\app
move app ..
del chrome.7z brave_installer-x64.exe 
goto :end

:Beta
set CHANNEL=Beta
goto GitHub
:Nightly
set CHANNEL=Nightly
goto GitHub

:GitHub
for /F "usebackq" %%i in (
	`busybox wget -q https://github.com/brave/brave-browser/releases/ -O - ^| ^
	busybox grep -Eom1 "%CHANNEL% v([0-9.])+" ^| busybox grep -Eo "v([0-9.])+"`
) do (
	set VERNUM=%%i
)
busybox wget https://github.com/brave/brave-browser/releases/download/%VERNUM%/brave-%VERNUM%-win32-x64.zip -O brave-%VERNUM%-win32-x64_%CHANNEL%.zip
7z x -aoa -oapp brave-%VERNUM%-win32-x64_%CHANNEL%.zip
rmdir /S /Q ..\app
move app ..
del brave-%VERNUM%-win32-x64_%CHANNEL%.zip
goto :end

:end
endlocal
echo.
pause
exit

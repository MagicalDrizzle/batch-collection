@echo off
setlocal enabledelayedexpansion
:start
echo Select channel:
echo [1] Release
echo [2] Beta (default)
echo [3] Nightly
set /P _input="> "
if not defined _input set _input=2
echo:
if "%_input%"=="1" goto :Release
if "%_input%"=="2" goto :Beta
if "%_input%"=="3" goto :Nightly
echo:
echo I couldn't understand you, pick one of the options
goto :start

:Release
set CHANNEL=release
goto GitHub
:Beta
set CHANNEL=beta
goto GitHub
:Nightly
set CHANNEL=nightly
goto GitHub

:GitHub
for /F "usebackq" %%i in (
	`busybox wget -q https://versions.brave.com/latest/%CHANNEL%-windows-x64.version -O -`
) do (
	set VERNUM=%%i
	for /F "usebackq" %%j in (`echo %%i ^| busybox sed "s/\.//g"`) do (set VERNUMSTRING=%%j)
)

for /F "usebackq" %%k in (
	`busybox find ../app -type d -maxdepth 1 ^| busybox grep -Eo "[0-9]+\.[0-9]+\.[0-9]+$"`
) do (
	set LOCAL=%%k
	for /F "usebackq" %%l in (`echo %%k ^| busybox sed "s/\.//g"`) do (set LOCALSTRING=%%l)
)

if %LOCALSTRING% equ %VERNUMSTRING% (
	echo ^> Local: %LOCAL%, Upstream: %VERNUM%
	echo ^> Up-to-date^^!
	goto end
) else if %LOCALSTRING% lss %VERNUMSTRING% (
	echo ^> Local: %LOCAL%, Upstream: %VERNUM%
	echo ^> New version available^^!
	choice /C YN /M "> Update?"
	if !errorlevel! equ 2 (goto end) else (goto Download)
) else (
	echo ^> Local: %LOCAL%, Upstream: %VERNUM%
	echo ^> Warning: You may have chosen an update channel more downstream than your local version.
	echo ^> For example, if you have Nightly version but you chose Beta/Release.
	echo ^> Only proceed if you are switching your update channel.
	choice /C YN /M "> Do you wish to update anyway?"
	if !errorlevel! equ 2 (goto end) else (goto Download)
)

:Download
busybox wget https://github.com/brave/brave-browser/releases/download/v%VERNUM%/brave-v%VERNUM%-win32-x64.zip -O brave-v%VERNUM%-win32-x64_%CHANNEL%.zip
busybox unzip -o -d app brave-v%VERNUM%-win32-x64_%CHANNEL%.zip
rmdir /S /Q ..\app && move app .. && del brave-v%VERNUM%-win32-x64_%CHANNEL%.zip
goto end

:end
endlocal
echo:
pause

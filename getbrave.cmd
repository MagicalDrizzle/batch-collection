@echo off
setlocal enabledelayedexpansion
:start
echo Select channel:
echo [1] Release (default)
echo [2] Beta
echo [3] Nightly
set /P _input="> "
if not defined _input set _input=1
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
	set REMOTEVER=%%i
)

for /F "usebackq" %%k in (
	`dir ..\app /B /A:D ^| busybox grep -Eo "[0-9]+\.[0-9]+\.[0-9]+$"`
) do (
	set LOCALVER=%%k
)

:: Comparison

for /F "usebackq" %%l in (
	`^(echo %LOCALVER% ^& echo:%REMOTEVER%^) ^| busybox sort -V ^| busybox head -1`
) do (
	set NEWESTVER=%%l
)

if %LOCALVER% == %REMOTEVER% (
	echo ^> Local: %LOCALVER%, Upstream: %REMOTEVER%
	echo ^> Up-to-date^^!
	goto end
) else if %LOCALVER% == %NEWESTVER% (
	echo ^> Local: %LOCALVER%, Upstream: %REMOTEVER%
	echo ^> New version available^^!
	choice /C YN /M "> Update?"
	if !errorlevel! equ 2 (goto end) else (goto Download)
) else if %REMOTEVER% == %NEWESTVER% (
	echo ^> Local: %LOCALVER%, Upstream: %REMOTEVER%
	echo ^> Warning: You may have chosen an update channel more downstream than your local version.
	echo ^> For example, if you have Nightly version but you chose Beta/Release.
	echo ^> Only proceed if you are switching your update channel.
	choice /C YN /M "> Do you wish to update anyway?"
	if !errorlevel! equ 2 (goto end) else (goto Download)
) else (
	echo Something terrible happened...
	echo Debug -- local: %LOCALVER% ^| remote: %REMOTEVER% ^| result: %NEWESTVER% 
	goto end
)

:Download
busybox wget https://github.com/brave/brave-browser/releases/download/v%REMOTEVER%/brave-v%REMOTEVER%-win32-x64.zip -O brave-v%REMOTEVER%-win32-x64_%CHANNEL%.zip
busybox unzip -o -d app brave-v%REMOTEVER%-win32-x64_%CHANNEL%.zip
rmdir /S /Q ..\app && move app .. && del brave-v%REMOTEVER%-win32-x64_%CHANNEL%.zip
goto end

:end
endlocal
echo:
pause

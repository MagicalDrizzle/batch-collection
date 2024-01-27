@echo off
setlocal enabledelayedexpansion
where /q busybox
if !errorlevel! neq 0 (
	echo ^> BusyBox not found^^!
	choice /C YN /M "> Do you wish to download BusyBox automatically?"
	if !errorlevel! equ 2 (
		echo ^> Download BusyBox here: https://frippery.org/files/busybox/busybox.exe
		echo ^> Manually put busybox.exe in either the directory containing this script, or your PATH.
		goto end
	) else (
		echo ^> Downloading BusyBox...
		curl https://frippery.org/files/busybox/busybox.exe -o busybox.exe
	)
)

:: First run
if not exist chrome_proxy.exe (
	choice /C YN /M "> Brave Browser not found^! Download?"
	if !errorlevel! equ 1 (
		set FIRSTRUN=true
		goto start
	) else (
		goto end
	)
)

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
	set REMOTEVER=%%i
)

if "%FIRSTRUN%"=="true" (
	echo ^> Downloading Brave Browser v%REMOTEVER%...
	goto :Download
)
 
for /F "usebackq" %%k in (
	`dir /B /A:D ^| busybox grep -Eo "[0-9]+\.[0-9]+\.[0-9]+$"`
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
if not defined FIRSTRUN (
	for /D %%k in (*.%LOCALVER%) do rmdir /S /Q %%k
	del brave.exe chrome_proxy.exe
)
busybox unzip -o brave-v%REMOTEVER%-win32-x64_%CHANNEL%.zip
del brave-v%REMOTEVER%-win32-x64_%CHANNEL%.zip
if not exist brave_portable.cmd (
	echo start "" brave.exe --user-data-dir=profile --no-default-browser-check --disable-machine-id --disable-encryption-win > brave_portable.cmd
)
echo %CHANNEL% > update_channel.txt
goto end

:end
endlocal
echo:
pause

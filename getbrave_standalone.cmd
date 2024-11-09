@echo off
setlocal enabledelayedexpansion
if exist busybox.exe goto first
busybox >nul 2>&1
if !errorlevel! equ 9009 (
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
:first
if not exist chrome_proxy.exe (
	choice /C YN /M "> Brave Browser not found^! Download?"
	if !errorlevel! equ 1 (
		set FIRSTRUN=true
		goto start
	) else if !errorlevel! equ 2 (
		goto end
	)
)

tasklist | findstr /C:brave.exe >nul
if !errorlevel! equ 0 (
	echo ^> Brave is running^^! Continue only if you are certain this specific Brave is not in use.
	choice /C YN /M "> Do you wish to continue?"
	if !errorlevel! equ 2 (
		goto end
	)
)

:start
echo Select channel:
echo [1] Release (default)
echo [2] Beta
echo [3] Nightly
echo [4] Check upstream versions
set /P _input="> "
if not defined _input set _input=1
echo:
if "%_input%"=="1" goto :Release
if "%_input%"=="2" goto :Beta
if "%_input%"=="3" goto :Nightly
if "%_input%"=="4" goto :CheckVer
echo:
echo I couldn't understand you, pick one of the options
goto :start

:CheckVer
for /F "usebackq" %%x in (
	`busybox wget -q https://versions.brave.com/latest/release-windows-x64.version -O -`
) do (
	echo Release: v%%x
)
for /F "usebackq" %%y in (
	`busybox wget -q https://versions.brave.com/latest/beta-windows-x64.version -O -`
) do (
	echo Beta:    v%%y
)
for /F "usebackq" %%z in (
	`busybox wget -q https://versions.brave.com/latest/nightly-windows-x64.version -O -`
) do (
	echo Nightly: v%%z
)
goto end

:Release
set CHANNEL=release
goto Arch
:Beta
set CHANNEL=beta
goto Arch
:Nightly
set CHANNEL=nightly
goto Arch

:Arch
choice /C YN /M "> Download 64bit build instead of 32bit?"
if !errorlevel! equ 1 (
	set BRAVE_ARCH=x64
	set BRAVE_ARCH_GH=x64
	goto GitHub
) else if !errorlevel! equ 2 (
	set BRAVE_ARCH=x86
	set BRAVE_ARCH_GH=ia32
	goto GitHub
)

:GitHub
for /F "usebackq" %%a in (
	`busybox wget -q https://versions.brave.com/latest/%CHANNEL%-windows-%BRAVE_ARCH%.version -O -`
) do (
	set REMOTEVER=%%a
)

if "%FIRSTRUN%"=="true" (
	echo ^> Downloading Brave Browser v%REMOTEVER%...
	goto :Download
)

for /F "usebackq" %%b in (
	`dir /B /A:D ^| busybox grep -Eo "[0-9]+\.[0-9]+\.[0-9]+$"`
) do (
	set LOCALVER=%%b
)

:: Comparison
for /F "usebackq" %%c in (
	`^(echo %LOCALVER% ^& echo:%REMOTEVER%^) ^| busybox sort -V ^| busybox head -1`
) do (
	set NEWESTVER=%%c
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
)

:Download
for /F "usebackq" %%d in (
	`busybox wget https://github.com/brave/brave-browser/releases/download/v%REMOTEVER%/brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%.zip.sha256 -q -O -`
) do (
	set REMOTEHASH=%%d
)
REM don't redownload
if exist brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip (
	for /F "usebackq" %%e in (
		`busybox sha256sum brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip`
	) do (
		set LOCALHASH=%%e
	)
	REM _ added for when localsize is empty
	if _%REMOTEHASH% == _!LOCALHASH! (
		echo Brave already downloaded^^!
		goto Download_Success
	)
)
busybox wget https://github.com/brave/brave-browser/releases/download/v%REMOTEVER%/brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%.zip -O brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip
if exist brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip (
	for /F "usebackq" %%f in (
		`busybox sha256sum brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip`
	) do (
		set LOCALHASH=%%f
	)
	REM _ added for when localsize is empty
	if _%REMOTEHASH% == _!LOCALHASH! (
		goto Download_Success
	) else (
		echo ^> Hash mismatch^^! Download probably got interrupted^^!
		del brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip
		goto end
	)
) else (
	echo ^> File doesn't exist^^! Download probably got interrupted^^!
	goto end
)


:Download_Success
if not defined FIRSTRUN (
	for /D %%g in (*.%LOCALVER%) do rmdir /S /Q %%g
	del brave.exe chrome_proxy.exe
)
busybox unzip -o brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip
del brave-v%REMOTEVER%-win32-%BRAVE_ARCH_GH%_%CHANNEL%.zip
if not exist brave_portable.cmd (
	echo start "" brave.exe --user-data-dir=profile --no-default-browser-check --disable-breakpad --disable-features=PrintCompositorLPAC --enable=features=brave-override-download-danger-level> brave_portable.cmd
)
echo # Launch brave_portable.cmd^^!
echo # This file contains the update channel this version of Brave is on.>> update_channel.txt
echo # Don't put anything here. It will be overwritten every update.>> update_channel.txt
echo %CHANNEL%>> update_channel.txt
goto end

:end
endlocal
echo Finished.
pause

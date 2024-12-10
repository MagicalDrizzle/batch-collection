@echo off

:getchannel
echo Select channel:
echo [1] Release (default)          [4] Beta
echo [2] ESR                        [5] Developer
echo [3] ESR115 (for Win7/8/8.1)    [6] Nightly
set /P _channelvalue="> "
if not defined _channelvalue set _channelvalue=1
echo:
if "%_channelvalue%"=="1" set _channel=LATEST_FIREFOX_VERSION
if "%_channelvalue%"=="2" set _channel=FIREFOX_ESR
if "%_channelvalue%"=="3" set _channel=FIREFOX_ESR115
if "%_channelvalue%"=="4" set _channel=FIREFOX_DEVEDITION
if "%_channelvalue%"=="5" set _channel=FIREFOX_DEVEDITION
if "%_channelvalue%"=="6" set _channel=FIREFOX_NIGHTLY
goto :getversion
echo:
echo I couldn't understand you, pick one of the options
goto :getchannel

:getversion
echo Choose version and press Enter (leave blank for latest):
set /P _versionvalue="> "
if defined _versionvalue (
	set _version=%_versionvalue%
) else (
	for /f "usebackq" %%i in (
		`busybox wget -q https://product-details.mozilla.org/1.0/firefox_versions.json -O - ^| busybox grep -hEo "%_channel%\": \"[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?" ^| busybox grep -hEo "[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?"`
	) do (
		set _version=%%i
	)
)

:getlang
echo Choose language and press Enter (leave blank for English):
set /P _langvalue="> "
if defined _langvalue (
	set _lang=%_langvalue%
) else (
	set _lang=en-US
)

:getarchname
echo Select OS:
echo [1] Windows 64bit (default)    [4] Linux 64bit
echo [2] Windows 32bit              [5] Linux 32bit
echo [3] Windows ARM64              [6] Mac
set /P _archvalue="> "
if not defined _archvalue set _archvalue=1
if "%_archvalue%"=="1" (
	set _arch=win64
	set _name=Firefox%%20Setup%%20%_version%.exe
	set _namedisk=Firefox Setup %_version%.exe
	set _namenightly=firefox-%_version%.%_lang%.win64.installer.exe
)
if "%_archvalue%"=="2" (
	set _arch=win32
	set _name=Firefox%%20Setup%%20%_version%.exe
	set _namedisk=Firefox Setup %_version%.exe
	set _namenightly=firefox-%_version%.%_lang%.win32.installer.exe
)
if "%_archvalue%"=="3" (
	set _arch=win64-aarch64
	set _name=Firefox%%20Setup%%20%_version%.exe
	set _namedisk=Firefox Setup %_version%.exe
	set _namenightly=firefox-%_version%.%_lang%.win64-aarch64.installer.exe
)
if "%_archvalue%"=="4" (
	set _arch=linux-x86_64
	set _name=firefox-%_version%.tar.bz2
	set _namenightly=firefox-%_version%.%_lang%.linux-x86_64.tar.xz
)
if "%_archvalue%"=="5" (
	set _arch=linux-i686
	set _name=firefox-%_version%.tar.bz2
	set _namenightly=firefox-%_version%.%_lang%.linux-i686.tar.xz
)
if "%_archvalue%"=="6" (
	set _arch=mac
	set _name=Firefox%%20%_version%.dmg
	set _namedisk=Firefox %_version%.dmg
	set _namenightly=firefox-%_version%.%_lang%.mac.dmg
)
goto :download
echo I couldn't understand you, pick one of the options
goto :getarchname

:download
if "%_channelvalue%"=="6" (
	echo Downloading Firefox: https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central-l10n/%_namenightly%
	pause
	busybox wget https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central-l10n/%_namenightly%
) else if "%_channelvalue%"=="5" (
	echo Downloading Firefox: https://ftp.mozilla.org/pub/devedition/releases/%_version%/%_arch%/%_lang%/%_name%
	pause
	busybox wget https://ftp.mozilla.org/pub/devedition/releases/%_version%/%_arch%/%_lang%/%_name%
) else (
	echo Downloading Firefox: https://ftp.mozilla.org/pub/firefox/releases/%_version%/%_arch%/%_lang%/%_name%
	pause
	busybox wget https://ftp.mozilla.org/pub/firefox/releases/%_version%/%_arch%/%_lang%/%_name%
)
:rename
:: only for non-linux
if "%_archvalue%" neq "4" (
	if "%_archvalue%" neq "5" (
		rename "%_name%" "%_namedisk%"
	)
)

pause
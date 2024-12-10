@echo off

:getchannel
echo Select channel:
echo [1] ESR (default)    [3] Beta
echo [2] Release          [4] Nightly
echo:
echo [0] Check latest versions
echo Note: ESR is the stable channel for Thunderbird.
echo 'Release' despite the name is intended for testing only.
set /P _channelvalue="> "
if not defined _channelvalue set _channelvalue=1
echo:
if "%_channelvalue%"=="0" (
	for /f "usebackq" %%i in (
		`busybox wget -q https://product-details.mozilla.org/1.0/thunderbird_versions.json -O - ^| busybox grep -hEo "THUNDERBIRD_ESR\": \"[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?" ^| busybox grep -hEo "[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?"`
	) do (
		echo Thunderbird ESR:     %%i
	)
	for /f "usebackq" %%i in (
		`busybox wget -q https://product-details.mozilla.org/1.0/thunderbird_versions.json -O - ^| busybox grep -hEo "LATEST_THUNDERBIRD_VERSION\": \"[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?" ^| busybox grep -hEo "[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?"`
	) do (
		echo Thunderbird Release: %%i
	)
	for /f "usebackq" %%i in (
		`busybox wget -q https://product-details.mozilla.org/1.0/thunderbird_versions.json -O - ^| busybox grep -hEo "LATEST_THUNDERBIRD_DEVEL_VERSION\": \"[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?" ^| busybox grep -hEo "[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?"`
	) do (
		echo Thunderbird Beta:    %%i
	)
	for /f "usebackq" %%i in (
		`busybox wget -q https://product-details.mozilla.org/1.0/thunderbird_versions.json -O - ^| busybox grep -hEo "LATEST_THUNDERBIRD_NIGHTLY_VERSION\": \"[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?" ^| busybox grep -hEo "[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?"`
	) do (
		echo Thunderbird Testing: %%i
	)
	pause
	exit
)
if "%_channelvalue%"=="1" set _channel=THUNDERBIRD_ESR
if "%_channelvalue%"=="2" set _channel=LATEST_THUNDERBIRD_VERSION
if "%_channelvalue%"=="3" set _channel=LATEST_THUNDERBIRD_DEVEL_VERSION
if "%_channelvalue%"=="4" set _channel=LATEST_THUNDERBIRD_NIGHTLY_VERSION
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
		`busybox wget -q https://product-details.mozilla.org/1.0/thunderbird_versions.json -O - ^| busybox grep -hEo "%_channel%\": \"[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?" ^| busybox grep -hEo "[0-9]+\.[0-9]+((\.|[ab])[0-9]+)?(esr)?"`
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
echo [1] Windows 64bit (default)    [4] Linux 32bit
echo [2] Windows 32bit              [5] Mac
echo [3] Linux 64bit
set /P _archvalue="> "
if not defined _archvalue set _archvalue=1
if "%_archvalue%"=="1" (
	set _arch=win64
	set _name=Thunderbird%%20Setup%%20%_version%.exe
	set _namedisk=Thunderbird Setup %_version%.exe
	set _namenightly=thunderbird-%_version%.%_lang%.win64.installer.exe
)
if "%_archvalue%"=="2" (
	set _arch=win32
	set _name=Thunderbird%%20Setup%%20%_version%.exe
	set _namedisk=Thunderbird Setup %_version%.exe
	set _namenightly=thunderbird-%_version%.%_lang%.win32.installer.exe
)
if "%_archvalue%"=="3" (
	set _arch=linux-x86_64
	set _name=thunderbird-%_version%.tar.bz2
	set _namenightly=thunderbird-%_version%.%_lang%.linux-x86_64.tar.xz
)
if "%_archvalue%"=="4" (
	set _arch=linux-i686
	set _name=thunderbird-%_version%.tar.bz2
	set _namenightly=thunderbird-%_version%.%_lang%.linux-i686.tar.xz
)
if "%_archvalue%"=="5" (
	set _arch=mac
	set _name=Thunderbird%%20%_version%.dmg
	set _namedisk=Thunderbird %_version%.dmg
	set _namenightly=thunderbird-%_version%.%_lang%.mac.dmg
)
if "%_archvalue%"=="6" (
	set _arch=win64-aarch64
	set _name=Thunderbird%%20Setup%%20%_version%.exe
	set _namedisk=Thunderbird Setup %_version%.exe
	set _namenightly=thunderbird-%_version%.%_lang%.win64-aarch64.installer.exe
)

goto :download
echo I couldn't understand you, pick one of the options
goto :getarchname

:download
if "%_channelvalue%"=="4" (
	echo Downloading Thunderbird: https://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-central-l10n//%_namenightly%
	pause
	busybox wget https://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-central-l10n/%_namenightly%
) else (
	echo Downloading Thunderbird: https://ftp.mozilla.org/pub/thunderbird/releases/%_version%/%_arch%/%_lang%/%_name%
	pause
	busybox wget https://ftp.mozilla.org/pub/thunderbird/releases/%_version%/%_arch%/%_lang%/%_name%
)
:rename
:: only for non-linux
if "%_archvalue%" neq "3" (
	if "%_archvalue%" neq "4" (
		rename "%_name%" "%_namedisk%"
	)
)

pause
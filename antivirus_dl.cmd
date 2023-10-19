@echo off
:start
echo Download:
echo [1] Kaspersky Virus Removal Tool
echo [2] Kaspersky Rescue ISO 2018
echo [3] Kaspersky Rescue ISO 2018 Base+Hash
echo [4] Kaspersky TDSS Killer
echo [5] DrWeb CureIt
echo [6] Emsisoft Emergency Kit
echo [7] Eset AVRemover
echo [8] Eset Online Scanner
echo [9] Eset SysInspector
set /P _inputname="> "
echo.
IF "%_inputname%"=="1" goto :KVRT
IF "%_inputname%"=="2" goto :KasperskyISO
IF "%_inputname%"=="3" goto :KasperskyISOBase
IF "%_inputname%"=="4" goto :KasperskyTDSS
IF "%_inputname%"=="5" goto :DrWebCureIt
IF "%_inputname%"=="6" goto :EEK
IF "%_inputname%"=="7" goto :EsetAVRemover
IF "%_inputname%"=="8" goto :EsetScanner
IF "%_inputname%"=="9" goto :EsetSysInspector
echo.
echo I couldn't understand you, pick one of the options
goto :start

:KVRT
busybox wget https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe -O KVRT_new.exe
if exist KVRT.exe (del KVRT.exe)
rename KVRT_new.exe KVRT.exe
goto :end

:KasperskyISO
busybox wget https://rescuedisk.s.kaspersky-labs.com/latest/krd.iso -O krd.iso
goto :end

:KasperskyISOBase
busybox wget https://rescuedisk.s.kaspersky-labs.com/updatable/2018/bases/042-freshbases.srm -O 005-bases.srm
busybox wget https://rescuedisk.s.kaspersky-labs.com/updatable/2018/bases/hashes.txt -O 005-bases.srm.sha512
goto :end

:KasperskyTDSS
busybox wget https://media.kaspersky.com/utilities/VirusUtilities/EN/tdsskiller.exe -O tdsskiller.exe
goto :end

:DrWebCureIt
busybox wget https://download.geo.drweb.com/pub/drweb/cureit/cureit.exe -O cureit_new.exe
if exist cureit.exe (del cureit.exe)
rename cureit_new.exe cureit.exe
goto :end

:EEK
busybox wget https://dl.emsisoft.com/EmsisoftEmergencyKit.exe -O EmsisoftEmergencyKit_new.exe
if exist EmsisoftEmergencyKit.exe (del EmsisoftEmergencyKit.exe)
rename EmsisoftEmergencyKit_new.exe EmsisoftEmergencyKit.exe
goto :end

:EsetAVRemover
busybox wget https://download.eset.com/com/eset/tools/installers/av_remover/latest/avremover_nt64_enu.exe -O avremover_nt64_enu.exe
goto :end

:EsetScanner
busybox wget https://download.eset.com/com/eset/tools/online_scanner/latest/esetonlinescanner.exe -O esetonlinescanner_new.exe
if exist esetonlinescanner.exe (del esetonlinescanner.exe)
rename esetonlinescanner_new.exe esetonlinescanner.exe
goto :end

:EsetSysInspector
busybox wget https://download.eset.com/com/eset/tools/diagnosis/sysinspector/latest/sysinspector_nt64_enu.exe -O sysinspector_nt64_enu.exe
goto :end

:end
echo.
pause
exit

@echo off 
echo [1] Restart Explorer
echo [2] Restart Explorer with pause
choice /C 12
if %errorlevel% equ 1 goto 1
if %errorlevel% equ 2 goto 2
:1
taskkill /f /im explorer.exe 
start explorer.exe
exit /b
:2
echo:
echo The explorer.exe process will be terminated 
taskkill /f /im explorer.exe
echo:
echo Press any key to start explorer.exe process
pause>nul
start explorer.exe
exit /b

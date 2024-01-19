@echo off
setlocal enabledelayedexpansion

set "_Key=HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
for /f tokens^=3 %%i in ('%__APPDIR__%reg.exe query "!_Key!"^|find/i "Personal"')do <con: call set "_docs_folder=%%~i"

set source=%CD%
set dest="!_docs_folder!\3ds Max 2024\materiallibraries"

robocopy %source% %dest% /e /xo

robocopy %dest% %source% /e /xo

echo synced material libraries

pause
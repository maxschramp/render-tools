@echo off
setlocal enabledelayedexpansion

REM Get current date and time components
for /f "delims=" %%a in ('wmic os get LocalDateTime ^| find "."') do set datetime=%%a

REM Extract year, month, day, hour, and minute
set year=!datetime:~0,4!
set month=!datetime:~4,2!
set day=!datetime:~6,2!
set hour=!datetime:~8,2!
set minute=!datetime:~10,2!

REM Create folder with formatted date-time
set folderName=!year!!month!!day!-!hour!h!minute!m
mkdir ".backups\!folderName!"

REM Set the source folder path
set "sourceFolder=C:\Users\Max\AppData\Local\Autodesk\3dsMax\2024 - 64bit\ENU\en-US\UI"

REM Set the destination folder path (current location)
set "destinationFolder=%CD%\.backups\!foldername!"

REM Use robocopy to copy the folder and its subdirectories
robocopy "%sourceFolder%" "%destinationFolder%" /E /NFL /NDL /NJH /NJS /nc /ns /np

@echo off
setlocal enabledelayedexpansion

set "parentDirectory=%CD%\.backups\"
set "subdirectoryPrefix="

cd /d "%parentDirectory%"

rem Get a list of subdirectories sorted by date (oldest first)
for /f "delims=" %%a in ('dir /b /ad /o:-n') do (
    set "subdirectory=%%a"
    
    rem Keep the latest 5 subdirectories, delete the older ones
    set /a count+=1
    if !count! gtr 5 (
        echo Deleting old backup: !subdirectory!
        rmdir /s /q "!subdirectory!"
    )
)

endlocal

echo Backed up "%sourceFolder%" to "%destinationFolder%"
pause
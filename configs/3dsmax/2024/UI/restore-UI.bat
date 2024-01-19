@echo off
setlocal enabledelayedexpansion

call backup-UI.bat

REM Set the destination folder path
set "destinationFolder=C:\Users\Max\AppData\Local\Autodesk\3dsMax\2024 - 64bit\ENU\en-US\UI"

REM Set the source folder path
set "sourceFolder=%CD%\.backups"

REM Display a numbered list of subdirectories
set "count=0"
for /d %%d in ("%sourceFolder%\*") do (
    set /a count+=1
    echo !count!. %%~nxd
    set "dir[!count!]=%%~nxd"
)

REM Prompt user to choose a subdirectory
set /p choice="Enter the number of the subdirectory to copy: "

REM Validate user input
if not defined dir[%choice%] (
    echo Invalid choice. Exiting script.
    exit /b 1
)

REM Use robocopy to copy the selected subdirectory to the destination folder
set "sourceSubdirectory=!sourceFolder!\!dir[%choice%]!"
robocopy "!sourceSubdirectory!" "%destinationFolder%" /MIR /NFL /NDL /NJH /NJS /nc /ns /np

echo Restored "!sourceFolder!" to "%destinationFolder%"

pause
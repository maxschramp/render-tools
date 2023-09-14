$paths = @("HKCU:\Software\Classes\Directory\Background\shell","HKCU:\Software\Classes\Directory\shell")

# Add Open in Adobe Bridge
foreach ($path in $paths) {
    # Add the entry
    $entryName = "Open in Adobe Bridge"
    New-Item -Path $path -Name $entryName -Force; $path = ($path+"\"+$entryName)
    New-ItemProperty -Path $path -PropertyType "string" -Name "position" -value "Top" -Force
    New-ItemProperty -Path $path -PropertyType "string" -Name "icon" -value "C:\Program Files\Adobe\Adobe Bridge 2023\BridgeDependencies\icons\BridgeApp.ico" -Force
    New-ItemProperty -Path $path -PropertyType "string" -Name "SeparatorBefore" -Force
    #New-ItemProperty -Path $path -PropertyType "string" -Name "SeparatorAfter" -Force

    # Add the command
    if ($path -like "*Directory\Background\shell*") { New-Item -Path $path -Name "command" -Value '"C:\Program Files\Adobe\Adobe Bridge 2023\Adobe Bridge.exe" "%V"' -Force }
    else { New-Item -Path $path -Name "command" -Value '"C:\Program Files\Adobe\Adobe Bridge 2023\Adobe Bridge.exe" "%L"' -Force }
}

$paths = @("HKLM:\*\shell")

# Add Exctract CXR
foreach ($path in $paths) {
    # Add the entry
    $entryName = "Extract CXR"
    New-Item -Path $path -Name $entryName -Force; $path = ($path+"\"+$entryName)
    New-ItemProperty -Path $path -PropertyType "string" -Name "position" -value "Top" -Force
    New-ItemProperty -Path $path -PropertyType "string" -Name "icon" -value "$env:APPDATA\Microsoft\Windows\SendTo\CoronaImageCmd.ico" -Force
    #New-ItemProperty -Path $path -PropertyType "string" -Name "SeparatorBefore" -Force
    New-ItemProperty -Path $path -PropertyType "string" -Name "SeparatorAfter" -Force

    # Add the command
    if ($path -like "*Directory\Background\shell*") { New-Item -Path $path -Name "command" -Value ('"'+$env:APPDATA+'\Microsoft\Windows\SendTo\sendto-extract.bat" "%w"') -Force }
    else { New-Item -Path $path -Name "command" -Value ('"'+$env:APPDATA+'\Microsoft\Windows\SendTo\sendto-extract.bat" "%1"') -Force }
}
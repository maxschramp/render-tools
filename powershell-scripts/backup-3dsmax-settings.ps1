<# sync 3dsmax settings #>
Clear-Host; Remove-Variable * -ErrorAction SilentlyContinue

<# locoate directories #>
$dir = (Get-Item $PSScriptRoot).Parent; Write-Host 'render-tools directory is: '$dir.FullName -ForegroundColor Blue
$dirProject = (Get-Item ([Environment]::GetFolderPath('MyDocuments')+'\3ds Max 2022')); Write-Host '3dsmax project directory is: '$dirProject.FullName -ForegroundColor Blue
$dirENU = (Get-Item ($env:APPDATA.Replace('Roaming','Local')+'\Autodesk\3dsMax\2022 - 64bit\ENU')); Write-Host '3dsmax settings directory is: '$dirENU.FullName -ForegroundColor Blue

$dirBackup = New-Item ($dir.FullName+'\.backup-3dsmax-settings\') -ItemType Directory -Force # create folder for backup

Write-Host 'Backing up 3dsmax settings in'$dirENU.Parent.FullName -ForegroundColor Yellow
Copy-Item -Path ($dirEnu.FullName) -Force -PassThru | Get-ChildItem | Compress-Archive -DestinationPath ($dirEnu.Parent.FullName+'\ENU.bak.'+(get-date -UFormat %y%m%d_%H%M%S)+'.zip') -CompressionLevel Optimal # create a zip backup of UI folder
Get-ChildItem -Path ($dirEnu.Parent.FullName) -Filter 'ENU.bak.*' | Sort-Object LastWriteTime -Descending | Select-Object -Skip 5 | Remove-Item -Recurse # delete any if more than 5

Write-Host 'Backing up most recent settings archive to '$dirbackup.FullName -ForegroundColor Yellow
Get-ChildItem -Path $dirBackup.FullName -Filter 'ENU.bak.*' | Sort-Object LastWriteTime -Descending | Select-Object | Remove-Item -Recurse # delete any backups if more than 5
Get-ChildItem -Path ($dirEnu.Parent.FullName) -Filter 'ENU.bak.*' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Copy-Item -Destination $dirBackup

Write-Host 'Backup complete!' -ForegroundColor Green

Pause
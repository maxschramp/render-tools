<# sync 3dsmax settings #>
Clear-Host; Remove-Variable * -ErrorAction SilentlyContinue

<# create symbolic links for material libraries to this git repository #>
$dir = (Get-Item $PSScriptRoot).Parent

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut(([Environment]::GetFolderPath("MyDocuments")+'\3ds Max 2022\materiallibraries\material-libraries.lnk'))
$Shortcut.TargetPath = ($dir.FullName+'\material-libraries\')
$Shortcut.Save()

Copy-Item $dir\configs\3dsmax\init-scene.max -Destination (([Environment]::GetFolderPath("MyDocuments")+'\3ds Max 2022\materiallibraries\material-libraries.lnk'))

#Copy-Item ($dir.FullName+'\lut') -Destination 'C:\Program Files\Corona\' -Container

[Environment]::SetEnvironmentVariable("RENDER_TOOLS", $env:RENDER_TOOLS + $dir.FullName, "Machine")
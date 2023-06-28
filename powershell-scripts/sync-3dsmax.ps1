<# sync 3dsmax settings #>
Clear-Host; Remove-Variable * -ErrorAction SilentlyContinue

<# create symbolic links for material libraries to this git repository #>
$dir = (Get-Item $PSScriptRoot).Parent

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut(([Environment]::GetFolderPath("MyDocuments")+'\3ds Max 2022\materiallibraries\material-libraries.lnk'))
$Shortcut.TargetPath = ($dir.FullName+'\material-libraries\')
$Shortcut.Save()

# Copy-Item $dir\configs\3dsmax\init-scene.max -Destination (([Environment]::GetFolderPath("MyDocuments")+'\3ds Max 2022\materiallibraries\material-libraries.lnk'))

#Copy-Item ($dir.FullName+'\lut') -Destination 'C:\Program Files\Corona\' -Container

# [Environment]::SetEnvironmentVariable("RENDER_TOOLS", $env:RENDER_TOOLS + $dir.FullName, "Machine")

<# Copy Render Settings template #>
Copy-Item ($dir.FullName+'\configs\3dsmax\ms-corona9-renderpreset.rps') -Destination (($env:APPDATA).Replace('Roaming','Local')+"\Autodesk\3dsMax\2022 - 64bit\ENU\en-US\StartupTemplates\renderpresets")

<# Generate custom paths .mxp linked to render-tools directory #>
Write-Host 'Adding paths to project folder'
$pathFile = (($env:APPDATA).Replace('Roaming','Local')+"\Autodesk\3dsMax\2022 - 64bit\ENU\en-US\StartupTemplates\StartupTemplates.mxp")
$dirAll = Get-ChildItem -Path $dir -Directory -Recurse
for ($i = 0; $i -lt $dirAll.Count; $i++) {
    Add-Content $pathFile -Value ('Dir'+(900 + $i)+'='+$dirAll[$i].FullName)
}
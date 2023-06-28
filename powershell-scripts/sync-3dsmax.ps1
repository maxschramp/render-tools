<# sync 3dsmax settings #>
Clear-Host; Remove-Variable * -ErrorAction SilentlyContinue

<# locoate directories #>
$dir = (Get-Item $PSScriptRoot).Parent; Write-Host 'render-tools direcotry is: '$dir.FullName
$dirProject = (Get-Item ([Environment]::GetFolderPath('MyDocuments')+'\3ds Max 2022')); Write-Host '3dsmax project directory is: '$dirProject.FullName

<# create material libraries shortcut #>

Write-Host 'Creating shortcut to material libraries...'
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut(($dirProject.FullName+'\materiallibraries\material-libraries.lnk'))
$Shortcut.TargetPath = ($dir.FullName+'\material-libraries\')
$Shortcut.Save()

<# Copy Render Settings template #>
Write-Host 'Adding render preset to project directory...'
Copy-Item ($dir.FullName+'\configs\3dsmax\ms-corona9-renderpreset.rps') -Destination ($dirProject.FullName+'\renderpresets\')

<# Generate custom paths .mxp linked to render-tools directory #>
Write-Host 'Adding paths to project folder...'

$paths = @()
$pathsExist = Get-Content ($dirProject.FullName+'\3ds Max 2022.mxp')
$pathsExist.ForEach( {
    if (($_.split('=')[0]).Split('Dir') -lt 900) { $paths+=$_ }
} )
Set-Content ($dirProject.FullName+'\3ds Max 2022.mxp') -Value $paths

$dirList = Get-ChildItem -Path $dir.FullName -Directory -Recurse

for ($i = 0; $i -lt $dirList.Count; $i++) {
    Add-Content -Path ($dirProject.FullName+'\3ds Max 2022.mxp') -Value ('Dir'+(900 + $i)+'='+$dirList[$i].FullName)
}

<# generate custom material library layout file #>

<# update material library or pull latest material libraries #>

# [Environment]::SetEnvironmentVariable("RENDER_TOOLS", $env:RENDER_TOOLS + $dir.FullName, "Machine") # Set the environment variable
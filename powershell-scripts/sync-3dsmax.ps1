<# sync 3dsmax settings #>
Clear-Host; Remove-Variable * -ErrorAction SilentlyContinue

<# locoate directories #>
$dir = (Get-Item $PSScriptRoot).Parent; Write-Host 'render-tools directory is: '$dir.FullName -ForegroundColor Blue
$dirProject = (Get-Item ([Environment]::GetFolderPath('MyDocuments')+'\3ds Max 2022')); Write-Host '3dsmax project directory is: '$dirProject.FullName -ForegroundColor Blue
$dirENU = (Get-Item ($env:APPDATA.Replace('Roaming','Local')+'\Autodesk\3dsMax\2022 - 64bit\ENU')); Write-Host '3dsmax settings directory is: '$dirENU.FullName -ForegroundColor Blue

<# create material libraries shortcut #>

Write-Host 'Creating shortcut to material libraries...' -ForegroundColor Yellow
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut(($dirProject.FullName+'\materiallibraries\material-libraries.lnk'))
$Shortcut.TargetPath = ($dir.FullName+'\material-libraries\')
$Shortcut.Save()

<# Copy Render Settings template #>
Write-Host 'Adding render preset to project directory...' -ForegroundColor Yellow
Copy-Item ($dir.FullName+'\configs\3dsmax\ms-corona9-renderpreset.rps') -Destination ($dirProject.FullName+'\renderpresets\')

<# Generate custom paths .mxp linked to render-tools directory #>
Write-Host 'Adding paths to project folder...' -ForegroundColor Yellow

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
Write-Host 'Backing up material library layout...' -ForegroundColor Yellow
Copy-Item ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl') -Destination ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl.bak.'+(get-date -UFormat %y%m%d_%Hh%Mm%Ss)) -Force

Write-Host 'Generating new material library layout...' -ForegroundColor Green
Copy-Item ($dir.FullName+'\configs\3dsmax\material-map-browser.mpl') -Destination ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl') -Force
$layoutSME = @(); $layoutSME = Get-Content ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl')
Set-Content ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl') -Value $layoutSME.Replace('%RENDERTOOLS%',$dir.FullName)

<# update material library or pull latest material libraries #>

<# copy scripts 
Write-Host 'Copying maxscript scripts...' -ForegroundColor Yellow
Copy-Item -Path 'S:\render-tools\plugins\3dsmax\ms' -Destination ($dirENU.FullName+'\scripts') -Container -Recurse -Force

Write-Host 'Copying startup scripts...' -ForegroundColor Yellow
Copy-Item -Path 'S:\render-tools\plugins\3dsmax\startup' -Destination ($dirENU.FullName+'\scripts\startup') -Container -Recurse -Force #>

<# set up simple UI #>

# [Environment]::SetEnvironmentVariable("RENDER_TOOLS", $env:RENDER_TOOLS + $dir.FullName, "Machine") # Set the environment variable
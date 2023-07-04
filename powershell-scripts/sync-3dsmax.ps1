<# sync 3dsmax settings #>
Clear-Host; Remove-Variable * -ErrorAction SilentlyContinue

<# locate directories #>
$dir = (Get-Item $PSScriptRoot).Parent; Write-Host 'render-tools directory is: '$dir.FullName -ForegroundColor Blue
$dirProject = (Get-Item ([Environment]::GetFolderPath('MyDocuments')+'\3ds Max 2022')); Write-Host '3dsmax project directory is: '$dirProject.FullName -ForegroundColor Blue
$dirENU = (Get-Item ($env:APPDATA.Replace('Roaming','Local')+'\Autodesk\3dsMax\2022 - 64bit\ENU')); Write-Host '3dsmax settings directory is: '$dirENU.FullName -ForegroundColor Blue

& ($dir.FullName+'\powershell-scripts\backup-3dsmax-settings.ps1')

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

<# Sync custom startup template #>
Write-Host 'Adding render-tools startup template...' -ForegroundColor Yellow
Copy-Item ($dir.FullName+'\configs\3dsmax\startup-template\render-tools.template') -Destination ($dirEnu.FullName+'\en-US\StartupTemplates\') -Force
Set-Content -path ($dirEnu.FullName+'\en-US\StartupTemplates\render-tools.template') -Value (Get-Content ($dirEnu.FullName+'\en-US\StartupTemplates\render-tools.template')).Replace('%RENDERTOOLS%',$dir.FullName) # replace %RENDERTOOLS% with proper directory

<# Sync startup scripts #>
New-Item -ItemType Directory -Path ($dirEnu.FullName+'\scripts\startup\render-tools\')
Copy-Item ($dir.FullName+'\scripts\3dsmax\ms-loader\setup-quads.ms') -Destination ($dirEnu.FullName+'\scripts\startup\render-tools\') -Force
Copy-Item ($dir.FullName+'\scripts\3dsmax\mcr\') -Destination ($dirEnu.FullName+'\scripts\startup\render-tools\') -Force -Container -Recurse

<# generate custom material library layout file #>
<# I need to convert this to checking and then adding to the .xml #>
Write-Host 'Backing up material library layout...' -ForegroundColor Yellow
Copy-Item ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl') -Destination ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl.bak.'+(get-date -UFormat %y%m%d_%Hh%Mm%Ss)) -Force

Write-Host 'Generating new material library layout...' -ForegroundColor Green
Copy-Item ($dir.FullName+'\configs\3dsmax\material-map-browser.mpl') -Destination ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl') -Force
$layoutSME = @(); $layoutSME = Get-Content ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl')
Set-Content ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl') -Value $layoutSME.Replace('%RENDERTOOLS%',$dir.FullName)
<#
# [xml]$mtlbrowser = Get-Content ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl') 
$xml = [xml](Get-Content ($dirEnu.FullName+'\en-US\defaults\MAX\MtlBrowser.mpl'))
# $xml.mtlbrowser.group.name
$names = $xml.mtlbrowser.group.name | Where-Object { $_ -like 'ms-corona*' }
$names.ForEach{
    Write-Host ('//group[@name="'+$_+'"]')
    $node = $xml.SelectSingleNode('//group[@name="ms-corona-default.mat"]'); 
    $node = $xml.SelectSingleNode('//group[@name="'+$_+'"]'); 
    $xml.mtlbrowser.RemoveChild($node) | Out-Null
}
$mtlbrowser.mtlbrowser.group
#>




<# update material library or pull latest material libraries #>

<# copy scripts 
Write-Host 'Copying maxscript scripts...' -ForegroundColor Yellow
Copy-Item -Path 'S:\render-tools\plugins\3dsmax\ms' -Destination ($dirENU.FullName+'\scripts') -Container -Recurse -Force

Write-Host 'Copying startup scripts...' -ForegroundColor Yellow
Copy-Item -Path 'S:\render-tools\plugins\3dsmax\startup' -Destination ($dirENU.FullName+'\scripts\startup') -Container -Recurse -Force #>

<# set up simple UI #>

# [Environment]::SetEnvironmentVariable("RENDER_TOOLS", $env:RENDER_TOOLS + $dir.FullName, "Machine") # Set the environment variable

Pause
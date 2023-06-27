git pull
git add --all
$message = Read-Host -Prompt 'commit message: (press enter for none)'; if ($message -eq '') {$message = 'syncing all changes'}
Write-Host 'commit message: '$message
git commit -m $message
git push
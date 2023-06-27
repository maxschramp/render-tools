git pull
git add --all
$message = Read-Host -Prompt 'commit message: (press enter for none)'; if ($message -eq '') {$message = 'syncing all changes'}
git commit -m $message
git push
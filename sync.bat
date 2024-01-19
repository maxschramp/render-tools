@echo off

git pull
git add --all

set /p msg="Enter a commit messsage: "

git commit -m "%msg%"

git push

pause
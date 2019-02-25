@echo off
setlocal EnableDelayedExpansion
where git >nul 2>nul
if %ERRORLEVEL% == 0 (
  echo Updating repositories...
  cd "%~dp0\.."
  echo Running 'git pull' in !cd!
  git pull
  if exist .vm-config.yaml (
    for /f "tokens=*" %%i in ('@findstr /ib user_provision_script: .vm-config.yaml') do set usrscriptline=%%i
    set usrscriptfile=!usrscriptline:~24,-1!
    for /f %%i in ("!usrscriptfile!") do set usrscriptpath=%%~di%%~pi
    cd !usrscriptpath!
    echo Running 'git pull' in !cd!
    git pull
  )
  cd "%~dp0"
  echo Finished updating repositories.
) else (
  echo Not updating repositories because 'git' is not installed.
)

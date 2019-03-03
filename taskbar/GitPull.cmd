@echo off
setlocal EnableDelayedExpansion
where git >nul 2>nul
if %errorlevel% == 0 (
  echo Updating provisioning repositories...
  cd "%~dp0\.."
  git ls-remote >nul 2>&1
  if %errorlevel% == 0 (
    echo Running 'git pull' in: !cd!
    git pull
  ) else (
    echo No remote configured in: !cd!
  )
  if exist .vm-config.yaml (
    for /f "tokens=*" %%i in ('@findstr /ib user_provision_script: .vm-config.yaml') do set usrscriptline=%%i
    set usrscriptfile=!usrscriptline:~24,-1!
    for /f %%i in ("!usrscriptfile!") do set usrscriptpath=%%~di%%~pi
    cd !usrscriptpath!
    git ls-remote >nul 2>&1
    if %errorlevel% == 0 (
      echo Running 'git pull' in: !cd!
      git pull
    ) else (
      echo No remote configured in: !cd!
    )
  )
  cd "%~dp0"
  echo Finished updating provisioning repositories.
) else (
  echo Not updating provisioning repositories because 'git' is not installed.
)

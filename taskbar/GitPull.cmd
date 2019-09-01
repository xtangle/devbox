@echo off
setlocal EnableDelayedExpansion
where git >nul 2>nul
if !errorlevel! == 0 (
  echo Updating provisioning repositories...
  cd "%~dp0\.."
  git ls-remote >nul 2>&1
  if !errorlevel! == 0 (
    echo Running 'git pull' in: !cd!
    git pull
  ) else (
    echo No remote configured in: !cd!
  )
  if exist .vm-config.yaml (
    for /f "tokens=*" %%i in ('@findstr /rc:"^  - .*" .vm-config.yaml') do (
      set arrayline=%%i
      set arrayval=!arrayline:~2!
      if exist !arrayval! (
        for /f %%i in ("!arrayval!") do set parentpath=%%~di%%~pi
        cd !parentpath!
        git ls-remote >nul 2>&1
        if !errorlevel! == 0 (
          echo Running 'git pull' in: !cd!
          git pull
        )
        cd "%~dp0"
      )
    )
  )
  cd "%~dp0"
) else (
  echo Not updating provisioning repositories because 'git' is not installed.
)

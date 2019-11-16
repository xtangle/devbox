@echo off
setlocal EnableDelayedExpansion

where git >nul 2>nul
if !errorlevel! == 0 (
  echo Updating provisioning repositories...
  call :git_pull "%~dp0\.."
  if exist .vm-config.yaml (
    set "npaths=0"
    for /F "tokens=* delims=" %%i in (.vm-config.yaml) do (
      set line=%%i
      if defined parsepath (
        set "pathmatch="
        echo !line! | >nul findstr /r /c:"^  [^:]*:[ ]*\".*\"[ ]*$" && set "pathmatch=y"
        if defined pathmatch (
          for /f delims^=^"^ tokens^=2 %%A in ('echo !line!') do (
            set /a "npaths+=1"
            set paths[!npaths!]=%%A
          )
        ) else set "parsepath="
      )
      echo !line! | >nul findstr /r /c:"^extra_steps:[ ]*$" && set "parsepath=y"
    )
    for /l %%n in (1 1 !npaths!) DO (
      set "filepath=!paths[%%n]!"
      for /f %%i in ("!filepath!") do set parentpath=%%~di%%~pi
      call :git_pull "!parentpath!"
    )
  )
  cd "%~dp0\.."
) else (
  echo Not updating provisioning repositories because 'git' is not installed.
)

exit /b 0

:git_pull
cd "%~1"
git ls-remote >nul 2>&1
if !errorlevel! == 0 (
  echo Running 'git pull' in: '!cd!'
  git pull
) else (
  echo No remote configured in: '!cd!'
)
cd "%~dp0\.."
exit /b 0

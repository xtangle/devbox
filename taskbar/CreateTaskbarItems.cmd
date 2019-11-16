@echo off

set TskDir=%~dp0
set TmpDir=%TskDir%tmp\
set IconFile=%TskDir%Vagrant.ico
set LinkFactoryFile=%TmpDir%CreateLink.vbs

if exist %TmpDir% rmdir /s /q %TmpDir%
mkdir %TmpDir%

call :create_link_file "%TmpDir%VagrantReload.lnk" "%TskDir%VagrantReload.cmd"
call :create_link_file "%TmpDir%VagrantReloadProvision.lnk" "%TskDir%VagrantReloadProvision.cmd"

exit /b 0

:create_link_file
echo Set oWS = WScript.CreateObject("WScript.Shell") > %LinkFactoryFile%
echo sLinkFile = "%~1" >> %LinkFactoryFile%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %LinkFactoryFile%
echo oLink.TargetPath = "cmd" >> %LinkFactoryFile%
echo oLink.Arguments = "/c ""%~2""" >> %LinkFactoryFile%
echo oLink.WorkingDirectory = "%TskDir%" >> %LinkFactoryFile%
echo oLink.IconLocation = "%IconFile%" >> %LinkFactoryFile%
echo oLink.Save >> %LinkFactoryFile%
cscript %LinkFactoryFile%
del %LinkFactoryFile%
echo Created link: '%~1'
echo.
exit /b 0

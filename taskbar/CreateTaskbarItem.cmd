@echo off

set TskDir=%~dp0
set TmpDir=%TskDir%tmp\
set TargetFile=%TskDir%TaskbarItem.cmd
set PinToTaskbarFile=%TskDir%PinToTaskbar.vbs
set IconFile=%TskDir%Vagrant.ico
set CreateLinkFile=%TmpDir%CreateLink.vbs
set LinkFile=%TmpDir%TaskbarItem.lnk

if not exist %TmpDir% mkdir %TmpDir%

echo Set oWS = WScript.CreateObject("WScript.Shell") > %CreateLinkFile%
echo sLinkFile = "%LinkFile%" >> %CreateLinkFile%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %CreateLinkFile%
echo oLink.TargetPath = "cmd" >> %CreateLinkFile%
echo oLink.Arguments = "/c ""%TargetFile%""" >> %CreateLinkFile%
echo oLink.WorkingDirectory = "%TskDir%" >> %CreateLinkFile%
echo oLink.IconLocation = "%IconFile%" >> %CreateLinkFile%
echo oLink.Save >> %CreateLinkFile%
cscript %CreateLinkFile%
del %CreateLinkFile%

cscript %PinToTaskbarFile% "%LinkFile%"

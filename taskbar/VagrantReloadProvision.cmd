@echo off

cd "%~dp0" && ^
UpdateRepositories && ^
cd "%~dp0\.." && ^
vagrant reload --provision

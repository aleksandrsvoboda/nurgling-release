@echo off
rem Starts Nurgling on Windows: applies a staged self-update, then runs the updater
rem with Nurgling's own Java (runtime\). The start line ends with "& exit /b" so cmd
rem never reads this file again once the updater (which may replace it) is running.
setlocal
cd /d "%~dp0"
if exist "nurgling-updater.jar.next" move /y "nurgling-updater.jar.next" "nurgling-updater.jar" >nul
if exist "runtime.next\bin\javaw.exe" if exist "runtime.old" rmdir /s /q "runtime.old" 2>nul
if exist "runtime.next\bin\javaw.exe" if exist "runtime" ren "runtime" "runtime.old" 2>nul
if exist "runtime.next\bin\javaw.exe" if not exist "runtime" ren "runtime.next" "runtime" 2>nul
set "J="
if exist "runtime\bin\javaw.exe" set "J=%~dp0runtime\bin\javaw.exe"
if not defined J if defined JAVA_HOME if exist "%JAVA_HOME%\bin\javaw.exe" set "J=%JAVA_HOME%\bin\javaw.exe"
if not defined J for %%i in (javaw.exe) do if not "%%~$PATH:i"=="" set "J=%%~$PATH:i"
if not defined J goto nojava
if not exist "nurgling-updater.jar" start "" "%J%" -jar "%~dp0hafen.jar" & exit /b
start "" "%J%" -jar "%~dp0nurgling-updater.jar" %* & exit /b

:nojava
echo Nurgling could not find Java on this computer.
echo Download the Nurgling package for Windows, which includes it:
echo   https://github.com/aleksandrsvoboda/nurgling-release/releases/latest
start "" "https://github.com/aleksandrsvoboda/nurgling-release/releases/latest"
pause
exit /b 1

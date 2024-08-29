@echo off
:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Clearing registry entries...
REM Delete registry keys under HKEY_CURRENT_USER
REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f
REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f
REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Bags" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\BagMRU" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Persisted" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\ShellNoRoam\MUICache" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /f

REM Delete registry keys under HKEY_LOCAL_MACHINE
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-910933839-4291352996-1289843923-1001" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-910933839-4291352996-1289843923-1001\Device\HarddiskVolume4\ProgramData\Solara\Solara.exe" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-910933839-4291352996-1289843923-1001\Device\HarddiskVolume4\Users\%userprofile%\Downloads\CeleryLatest\CeleryApp.exe" /f


echo Clearing temporary files and folders...
rmdir /s /q "C:\Users\%username%\AppData\Local\Temp"
@RD /S /Q "C:\Windows\Prefetch\"
echo Cleared Windows Prefetch.
@RD /S /Q "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Recent\"
echo Cleared Windows Recent Data.
@RD /S /Q "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Recent\"

echo Waiting for 3 seconds...
timeout /t 3 /nobreak >nul

echo Clearing Prefetch folder...
del /s /f /q C:\Windows\Prefetch
echo Prefetch folder cleared.

echo Cleaning event logs...
FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")

:do_clear
echo Cleaning %1
wevtutil.exe cl %1

echo All tasks completed.
pause
exit

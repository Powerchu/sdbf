@echo off 

echo [101;93m====================================================================[0m
echo [101;93m                 Scheduled Deletion Batch File v0.1                 [0m
echo [101;93m====================================================================[0m
echo [91mSDBF v0.1 is created by Aaron Chu, 13/1/2021.[0m
echo SDBF automatically adds this batch file to Microsoft Task Scheduler and runs it
echo during windows logon. YOU ONLY NEED TO RUN THIS BATCH FILE MANUALLY ONCE.
echo.
echo For now, SDBF only allows for a fixed number of folders to parse (four).
echo They are 1) Daily, which deletes files and folders older than 2 days
echo          2) Weekly, which deletes files and folders older than 7 days
echo          3) Monthly, which deletes files and folders older than 31 days
echo          4) Bi-Annual, which delete files and folders older than 180 days
echo.


 :: set current directory
    
    set currDir=%~dp0
    set fileName=%~dpnx0
	
:: set Task Scheduler Bool
    IF DEFINED SDBF_RUN_ONCE (
        ECHO SDBF_RUN_ONCE IS defined
    ) ELSE (
    setx SDBF_RUN_ONCE 1
        schtasks /Create /TR %fileName% /TN ScheduledDeletionTask /SC ONLOGON
    )
    pause
    
 :: set folder path 

    set dailydump=%currDir%0_Daily
    set weeklydump=%currDir%1_Weekly
    set monthlydump=%currDir%2_Monthly
    set biannualdump=%currDir%3_Bi-Annually
    
 :: create folders if do not exist
    if not exist %dailydump%\NUL mkdir 0_Daily
    if not exist %weeklydump%\NUL mkdir 1_Weekly
    if not exist %monthlydump%\NUL mkdir 2_Monthly
    if not exist %biannualdump%\NUL mkdir 3_Bi-Annually
    
 :: set min age of files and folders to delete 

    REM setting to max of 1 day seems too strict and often leads to regret
    set daily=2 
    set weekly=7
    set monthly=31
    set biannual=180
    
 :: set log files names (.log for stdout and .err for stderr)
    
    set logName=deletelog.log
    set errName=deletelog.err
    
:: First Time Use
    IF NOT EXIST %logName% (
          echo ==================================================
          echo         Scheduled Deletion Batch File v0.1        
          echo ==================================================
          echo.
          echo This file logs all deleted files as well as the date it was deleted.
          echo.
        ) > %logName%
        
    if not exist "%currDir%%errName%" (
          echo ==================================================
          echo         Scheduled Deletion Batch File v0.1        
          echo ==================================================
          echo.
          echo This file logs any errors prompted by forfiles.exe.
          echo.
        ) > %errName%
    
    
:: Timer
    :loop
    choice /t 5 /c yn /d n /n /m "Do you want to remove the task? Deletion will continue after 5 seconds. (Y/N)?"
    if errorlevel 3 goto :loop
    if errorlevel 2 goto :no
    if errorlevel 1 goto :yes

    :yes
    @echo Removing SDBF_RUN_ONCE variable and the task from Task Scheduler.
    GOTO :change_setting

    :no
    @echo Proceeding with scheduled deletion.
    GOTO :continue

    :continue
    
    :: remove files from %dump_path%

    forfiles -p %dailydump% -m *.* -d -%daily% -c "cmd /c del /q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul

    :: remove sub directories from %dump_path%

    forfiles -p %dailydump% -d -%daily% -c "cmd /c IF @isdir == TRUE rd /S /Q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul
     
    :: remove files from %dump_path%

    forfiles -p %weeklydump% -m *.* -d -%weekly% -c "cmd /c del /q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul

    :: remove sub directories from %dump_path%

    forfiles -p %weeklydump% -d -%weekly% -c "cmd /c IF @isdir == TRUE rd /S /Q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul
     
    :: remove files from %dump_path%

    forfiles -p %monthlydump% -m *.* -d -%monthly% -c "cmd /c del /q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul

    :: remove sub directories from %dump_path%

    forfiles -p %monthlydump% -d -%monthly% -c "cmd /c IF @isdir == TRUE rd /S /Q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul
     
    :: remove files from %dump_path%

    forfiles -p %biannualdump% -m *.* -d -%biannual% -c "cmd /c del /q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul

    :: remove sub directories from %dump_path%

    forfiles -p %biannualdump% -d -%biannual% -c "cmd /c IF @isdir == TRUE rd /S /Q @path && echo @path on %DATE%>>%currDir%%logName% | echo 2>>%currDir%%errName%" 2>&1 |  findstr /V /O /C:"ERROR: No files found with the specified search criteria."2>&1 | findstr ERROR&&ECHO found error||ver > nul
    
    exit
    :change_setting
	SchTasks /Delete /TN ScheduledDeletionTask /f
	REG delete HKCU\Environment /F /V SDBF_RUN_ONCE
	REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V SDBF_RUN_ONCE
	
	pause
@echo OFF
@title Rust Better Backup - Running
@setlocal enabledelayedexpansion

@echo ** Delete OLD Oxide/Server instance log files before running!
@echo ** Set proper folders in batch file before running!
@echo ** Exit to edit/adjust/delete, or 
@echo ===========================================================================
@echo The backup starts in backup folder 1, and will overwrite/update that backup
@echo Rename/move folders if you do NOT want older backups overwritten!!!
@echo OR set the value of "C" to the folder you want backup to start in
@echo After the run is completed, the next run will start at 1
@echo ===========================================================================
@pause

:: === EDIT DIRECTORIES for your install location
@set RustDir=r:\rustserver
@set ServerDir=r:\rustserver\server\server1

:: === EDIT the number of daily backups you want to create (Default is 12, every 2 hours)
@set /A D=12
:: Number of days in a week to do backups
@set /A W=4
:: Backup Folder to start in (must be in the range of D * W
@set /A C=7

:: === No Editing the rest of the file

:: Total number of backups need
@set /A T=%D%*%W%

:: === These are the defaults Oxide and BetterBU directories.  Do not change
@set OxideDir=%RustDir%\Oxide
@set BackupDir=%RustDir%\BetterBU

:: === Setting up the backup frequency, and the ping timer
:: Ping is used to "wait" til the next backup
:: BackupFreq is in minutes 

@set /A PingCount = 86400/%D%
@set /A BackupFreq=%PingCount%/60

:: === Variable Roll Call to confirm accuracy/correctness
@echo :: These are the current variable settings ::
@echo :: %RustDir% is the base rust install
@echo :: %ServerDir% is the rust server instance directory
@echo :: %D% backups each day
@echo :: %OxideDir% is the oxide install directory
@echo :: %BackupDir% is the directory to store backups
@echo :: %PingCount% is the number of pings to send
@echo :: %BackupFreq% minutes pass between each backup
@echo :: %T% is total number of backups and folders needed
@echo :: %W% = Number of days in a row to do backups before restarting
@echo :: %C% is the starting backup folder.  Should be lower than %T%.

@echo Confirming and creating folders
:: === Setting up the folders

:: Create the Backup Folder, BetterBU, under the Rust Server's root directory
@if not exist %BackupDir% (md %RustDir%\BetterBU)

:: Creating 1 folder for each backup of the day, based on Daily Backup Count
For /L %%i IN (1,1,%T%) DO  (  if not exist "%BackupDir%\%%i" (md %BackupDir%\%%i) ) 
:: Making a server1 subfolder
For /L %%i IN (1,1,%T%) DO  (  if not exist "%BackupDir%\%%i\server1" (md %BackupDir%\%%i\server1) ) 
:: Making an Oxide subfolder
For /L %%i IN (1,1,%T%) DO  (  if not exist "%BackupDir%\%%i\oxide" (md %BackupDir%\%%i\oxide) ) 

@pause

:BackupRoutine
@cls
:: Backing up the *oxide* folder as well as *server instance* folder
:: === Starting the Backup Process
:: Backing up ServerDir and OxideDir

For /L %%i IN (%C%,1,%T%) DO  ( ( (echo %date% %time% > %BackupDir%\%%i\TimeStamp.txt) & (echo This is run %%i of %T%) & (xcopy /d /e /c /h /y %RustDir%\Oxide\*.* %BackupDir%\%%i\Oxide\) & (xcopy /d /e /c /h /y %ServerDir%\*.* %BackupDir%\%%i\Server1\) & (echo Finished Backup %%i - Pausing %BackupFreq% minutes) & (echo Run %%i of %T% complete) & (ping 127.0.0.1 -n %PingCount% >NUL) ) ) 

@set /A C=1

GoTo :BackupRoutine

@echo END OF ROUTINE
Pause




# RustBetterBackup

This is public, but is NOT quite ready for use.  But it's close.  If you're comfortable editing a batch file, you can pretty easily make it work 
in your environment.  The *only* thing remaining: Check the path's around line 74, to make sure they'll capture your server instances.
I hardcoded late last night, and haven't switched/updated/corrected the variables.  That's really all that needs to be done.  It's running 
like a champ.

DESCRIPTION

This script is designed for Windows-based Rust servers

I have not had much success "rolling back" to a prior state with the default facepunch backups.  Probably user error, but, when every backup folder has the same
name, it's a bit hard to know which one is even the right one.

This script backs up your Oxide folder, as well as your Server instance folder.  It creates a file with the time stamp in the root of the backup folder, so you 
know exactly when that backup was created.  Because it backs up Oxide and your Server, you should be able to restore to any point in time that you have a backup for.

INSTRUCTIONS

*BACKING UP*

Edit the following lines as needed:

     :: === EDIT DIRECTORIES for your install location
     @set RustDir=r:\rustserver
     @set ServerDir=r:\rustserver\server\server1

     :: EDIT the number of daily backups you want to create (Default is 12, every 2 hours)
     @set /A D=12
     :: Number of days in a week to do backups
     @set /A W=4
     :: Backup Folder to start in (must be in the range of D * W
     @set /A C=7
     
*RESTORING A BACKUP*

0) Shut down your server.  Close any windows that may be open.
1) Identify the folder which has the backup you want to restore - review the folder timestamp.txt file if needed to confirm date/time of backup
2) Rename the existing server instance folder (such as c:\rust\server\server1) to a backup name (i.e. Server1-bak)
3) Copy the Server Instance folder (such as Server1) from the backup folder to your Rust installation Server folder, such as c:\rust\server\
4) Rename your Oxide folder (such as c:\rust\oxide) to Oxide-bak (c:\rust\oxide-bak)
5) Copy the backup oxide folder to your rust installation folder (such as c:\rust)
6) Start up your server.

RESTARTING THE SCRIPT

The script makes 1 folder for each backup.  If you restart the script, it will by default start at folder 1, regardless of how many 
folders you have.  This means it will overwrite backups.  If you want it to start at a specific folder, set the "C" variable to the 
folder you want to put the first backup in.  The script will finish the rest of the backups, and then start the next run of 
backups at folder #1.

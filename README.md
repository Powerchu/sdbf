# SDBF v0.1
Scheduled Deletion Batch File - Run this batch file once to add a task that delete files based on different file age.

## What is it
SDBF is a simple batch file that will be run every time a user logs on. This then checks for the managed folders and delete according to the age of files and folders. SDBF essentially takes a 22-pointer from https://pureinfotech.com/delete-files-older-than-days-windows-10/ and condense it into a .bat file.

## Why to use
I was primarily motivated as before this, I was lazy to organise my download folder, and download a huge amount of files for setting up fresh installs of windows. It was especially bad when it comes to downloading mods for video games, since they often come in compressed archive format. Which means, I always end up saving the archive, and extracting the content, and never touch the archive again. You may ask: "Why not just 'run' the archive instead of saving"? Well, sometimes, the mod installation doesn't go well and problem arises whereby an overwrite is necessary.

## Who should use
Lazy and cheap people who does not want to use programs like CCleaner, but download alot of temporary files. This is a launch-once-and-forget kinda deal.

## How to use
  0. Download by clicking the green Code button then Download As Zip.
  1. Extract the batch file to the folder that you want to create managed folders (usually this is C:\users\xx\downloads)
  2. Run the batch file with admin privileges. Either press N or ignore the prompt for 5 seconds.
  3. This will do three things:<br>
    a. It will create four folders: i) Daily, ii) Weekly, iii) Monthly and iv) Bi-Annually. Files and folders inside <Daily> are removed if they are older than 2 days, and those inside <Monthly> are removed if they are older than 31 days, etc etc.<br>
    b. Create two text files: deletelog.log and deletelog.err in the directory the batch file is in. You can view deletelog.log to see the files that have been deleted.<br>
    c. Create a task <ScheduledDeletionTask> in Windows Task Scheduler, which will run this batch file each time a user logs on to the computer. This will then run the           deletion based on age.<br>
  4. That's it! Now whenever you are downloading files, choose a folder than you deem the correct duration to have. For example, if its a file you just need immediately and wont need it ever again, put into Daily. If it is something you think you might need in the next month or so, put into Monthly.
  
## How it works
SDBF primarily uses [forfiles.exe](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/forfiles "Microsoft Docs: Forfiles") for the actual removal, and [schtasks.exe](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks "Microsoft Docs: Schtasks") for creating the windows task. This batch file does create a user environment variable and stores it in the registry. I use this to check if the task needs to be created in the first place (for first time users; I definitely need a better way to do this).
  
## Want-list
  1. Cleaner batch code
  2. The ability for users to customise their deletion: i.e. choose how many folders to be managed, the names of these folders, names of logging text files and setting of the frequencies through the batch file itself (command prompt). Right now, users have to edit the code which is unsightly to begin with.
  3. The option to move files into recycle bin instead and to restore files of a particular age from the recycle bin.
  4. The option to review files selected for purging, and then confirming the deletion.

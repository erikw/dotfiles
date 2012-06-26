@echo off
REM Use the folder ~/pub on the host OS as a shared folder. Set up Via Devices->Shared Folders.
net use x: \\vboxscr\pub -p

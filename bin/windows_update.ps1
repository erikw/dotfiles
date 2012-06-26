# Update Windows with Scoop and Chocolatey.
#
# Tip: create a shortcut on your desktop to run this file.
# 1. Right click on Desktop
# 2. New > Shortcut
# 3. Enter path:
# powershell -noexit "& ""C:\Users\erikw\.dotfiles\bin\windows_update.ps1"""
# 4. Enter name: windows_update.ps1
# 5. Right click on it at "Run as Administrator" to run update.
# Reference: https://stackoverflow.com/questions/10137146/is-there-any-way-to-make-powershell-script-work-by-double-clicking-ps1-file

Write-Output "> Upgrading chocolately apps."
choco upgrade all
Write-Output "> Upgrading chocolately apps. - DONE"

write-Output "`n`n`n`n"
write-Output "> Updating scoop."
scoop update
write-Output "> Updating scoop. - DONE"

write-Output "`n`n`n`n"
write-Output "> Updating scoop programs."
scoop update *
write-Output "> Updating scoop programs. - DONE"

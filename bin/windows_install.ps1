﻿# #requires -version 4.0
#requires –runasadministrator

# Install script for my Windows setup.
# Run this in an administrative Powershell prompt (for chocolately).
# To download-and-execute:
# $ iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/erikw/dotfiles/main/bin/windows_install.ps1')

# Modeline {
#	vi: foldmarker={,} filetype=sh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4
# }


# Scoop {
# CLI developer programs. http://scoop.sh/
set-executionpolicy remotesigned -s cu
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

# scoop install aria2 use multi download connections if aria2 is installed
scoop install aria2
scoop config aria2-warning-enabled false

# Could migrate list to a packages.config
# https://github.com/ScoopInstaller/Scoop/issues/1543#issuecomment-308894312
# but it's nice to keep this self-contaied so it can be downloaded an executed direclty

# NOTE mind the space before closing double quote.
$scoop_prgs =
"7zip " +
"ack " +
"concfg " +
"cowsay " +
"ctags " +
"curl " +
"dig " +
"fd " +
"file " +
"gdb " +
"git " +
"grep " +
"latex " +
"make " +
"octave " +
"openssh " +
"patch " +
"ripgrep " +
"sed " +
"ssh-copy-id " +
"tar " +
"time " +
"unzip " +
"vim " +
"wget " +
"which " +
"zip " +
""
Invoke-Expression "scoop install $scoop_prgs"

# Theme powershell.
concfg import solarized-dark

# Pimp up the powershell prompt
scoop install pshazz

# Update all scoop programs with
# $ scoop update *


# }

# Chocolatey {
# GUI apps. https://chocolatey.org/
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

# Skip confirmation for every package.
choco feature enable -n=allowGlobalConfirmation

# Could migrate list to a packages.config
# https://docs.chocolatey.org/en-us/choco/commands/install#packages.config
# but it's nice to keep this self-contaied so it can be downloaded an executed direclty

$choco_apps =
"auto-dark-mode " +
"choco-cleaner" +
"git " +
"googlechrome " +
"icloud " +
"libreoffice " +
"microsoft-windows-terminal " +
"notepadplusplus " +
"nanazip " +
"neovim " +
"putty " +
"powertoys " +
"sumatrapdf " +
"vlc " +
"vscode " +
"whatsapp " +
"windirstat " +
"zeal " +
""

# $choco_apps_additional =
# "7zip " + # Replaced by nanazip
# "autohotkey " + # Replaced by PowerToys
# "battle.net" +
# "bleachbit " + # # Replaced by Windows 11 built-in system settings cleanup too.
# "cygwin " + # Replaced by WSL
# "dropbox " +
# "deluge " +
# "discord " +
# "ditto " + # Replaced by Windows 11 built-in
# "eartrumpet " + # Replaced by Windows 11 built-in
# "epicgameslauncher " +
# "f.lux " + # Replaced by Windows 11 built-in
# "firefox " +
# "flameshot " + # Replaced by Windows 11 built-in Snipping tool
# "javaruntime " +
# "littleregistrycleaner" + # Should not have any benefits on modern Windows.
# "openhardwaremonitor " + # Replaced by Windows Task Manager's Performance tab.
# "origin " +
# "quicklook " + # Replaced by Powertoys
# "signal " +
# "spotify " +
# "steam " +
# "velocity " +
# "virtualclonedrive " +
# "winscp " +
# "winxcorners " + # Replaced by Windows 11 built-in virtual desktop taskbar icon
# ""



Invoke-Expression "choco install $choco_apps"
#Invoke-Expression "choco install $choco_apps_additional"

# Chcos with installoptions
# TODO next time, switch from chocolately to buil-in winget
Invoke-Expression "choco install vim --params /NoDesktopShortcuts"

# Upgrade system with
# $ choco upgrade all

# }


# Manually install {

# * Windows Link phone app to mirror notifications to windows. 
# * Drivers. For Thinkpad, download  http://pcsupport.lenovo.com/de/en/products/Laptops-and-netbooks/ThinkPad-T-Series-laptops/ThinkPad-T430/downloads)
# * Lenovo ThinkVantage System Update utility,
# * Lenovo Power Manager Driver
# * Lenovo Vantage (avilable from Microsoft Store too).
# * Intel HD Graphics Driver for Windows 10


# * Brother DCP-7070DW drivers "Printer Driver & Scanner Driver for Local Connection": http://support.brother.com/g/b/downloadlist.aspx?c=eu_ot&lang=en&prod=dcp7070dw_eu&os=10013
# ** Then go to Settings > Devices > Printers & Scanners, find the printer on the network and add it.
# ** Then Press "Manage" to set paper size, Duplex etc.
# * Hamachi: https://www.vpn.net/
# * Messenger for Desktop (no chocolately package): https://messengerfordesktop.com/
# * x-chat 2 silverex: http://www.silverex.org/download/
# * Serato: https://serato.com/dj/downloads
# * DDJ-SR drivers: https://www.pioneerdj.com/en/support/software/ddj-sr/
# * AoE3 loader: http://www.crea-doo.at/weblog/2006/02/13/age-of-empires-iii-loader/comment-page-5/
# * Logitec Gaming Software (for configuring my G700s mouse): http://support.logitech.com/en_us/product/g700s-rechargable-wireless-gaming-mouse
# * CCleaner: https://www.piriform.com/ccleaner/download
#
## From Windows app store:
# * Windows Scan
#
#
#
## Linux Subsystem for Windows
# * In a administrative powershell: $ Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# * Then go to Microsoft Store and download a Linux Distribution.
# Reference: https://docs.microsoft.com/en-us/windows/wsl/install-win10


# Hamachi by Logmein, for LAN play: https://www.vpn.net/
# }



# Configuration {

# Set up dotfiles. See https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
# Do this in git-bash!
# git-bash$ ssh-keygen -t rsa -C "erikw@$HOSTNAME"
# git-bash$ eval $(ssh-agent -s)
# git-bash$ ssh-add ~/.ssh/id_rsa
# Copy ~/.ssh/id_rsa.pub to Github profile
# git-bash$ mkdir -p ~/src/github.com/erikw
# git-bash$ cd !$
# git-bash$ git clone git@github.com:erikw/dotfiles.git
# git-bash$ git checkout -b local
# Because bin/dfm does not work on Windows (infinite recursions), instead in a privilegied powershell install some symlinks:
# pwrshl$  New-Item -Path ~/.vimperatorrc -ItemType SymbolicLink -Value ~/src/github.com/erikw/dotfiles/.vimperatorrc
# pwrshl$  New-Item -Path ~/.tridactylrc -ItemType SymbolicLink -Value ~/src/github.com/erikw/dotfiles/tridactylrc
# pwrshl$  New-Item -Path ~/.gitconfig -ItemType SymbolicLink -Value ~/src/github.com/erikw/dotfiles/.gitconfig



# Windows Desktop shortcuts to add:
# * Whatsapp: Is installed in %USER%\AppData\Local\Whatsapp
# * ~/src/github.com/erik/dotfiles/bin/windows_update.ps1: Right click on Desktop > New > Shortcut > Enter: powershell.exe -command "& 'C:\Users\erikw\src\github.com\erikw\dotfiles\bin\windows_update.ps1'"
# * Lenovo vantage: to upgrade firmwares
# * Windows Upgrade: Right click on desktop > New > Shortcut > Location: "ms-settings:windowsupdate" > Name: Windows Upgrade.
# * Power Shell
# * git-bash
# * putty. To make it start a specific profile, append this to the "taraget path": -load "profilename"





# Taskbar (right click on)
# * Cortana > uncheck "Show Cortana icon"
# * Search > check "Hidden"


# Start menu
# * Remove all tiles to get a single column start menu.

# Create link to User's folder in the taskbar:
# 1. Right click on the desktop > New > Shortcuts
# 2. Enter destination "explorer shell:UsersFilesFolder"
# 3. Enter the user's name as name.
# 4. Drag the shortcut to the task bar.
# 5. Delete the shortcut from the desktop.
# Also drag C:\Users\erikw to the Explorer shortcut left column.

# Windows Explorer
# * View > Options > 
## General
# * Open File Explorer to: This PC (instead of Quick Access)
## View
# - check: Display full path in the title bar
# - check: Show hidden files, folders, and drives
# - uncheck: Hide extentions for known file types
# * My Computer > right click > Add a network location > \\<local-smb-server-ip\pub


# CTRL+ALT+ESC > Startup, disable all but the essentials.

# * Create folders in My Documents: tmp, doc, bin, pub

# AutoHotkey
# NOTE replaced by PowerToys
# * Press Win+R and type "shell:Startup"
# * Make a shortcut from within this folder to v1 or v2 version of AHK:
# ~/src/github.com/erikw/dotfiles/.config/autohotkey/AutoHotkey_v1.ahk
# ~/src/github.com/erikw/dotfiles/.config/autohotkey/AutoHotkey_v2.ahk

# Ditto
# NOTE windows has built+in clipboard history now on win+v. Ref: https://www.howtogeek.com/671222/how-to-enable-and-use-clipboard-history-on-windows-10/
# * Right click on taskbar icon > Options
# * General > Paste entries expires after: 1 day
# * Keyboard Shortcuts > Activate Ditto: Ctrl + Alt + v

# Flameshot
# Actually the built-in screenshot tool is enough (win10: Snip & Sketch, win11: Snipping tool). 
## Use Win+PrtSc to automatically save screenshot to Screenshots folder, Win+Shift+S for rectangular area selection.


# Linux, macOS and sane OSes store and interpret the hwclock as UTC time, while Windoze insists on it being in the local timezone...
# Fix this by setting a new regedit flag (run in privilegied powershell):
# Ref: http://lifehacker.com/5742148/fix-windows-clock-issues-when-dual-booting-with-os-x
# Ref: http://stackoverflow.com/questions/26719206/powershell-create-registry-path-one-liner
New-ItemProperty -Path Registry::HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation -Name RealTimeIsUniversal -Value 1 -Force | Out-Null



# Disable PIN login for security. Reference: https://www.top-password.com/blog/disable-pin-login-in-windows-10-8/
#New-ItemProperty -Path Registry::HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions -Name value -Value 0 -Force
# NOPE that does not work. Simply dismiss the PIN code creation.


# Create desktop shortcut to openHardwareMonitor, as the chocolatey installed does not add desktop or start menu shortcuts.
# Reference: https://www.pdq.com/blog/pdq-deploy-and-powershell/
$TargetFile = "C:\ProgramData\chocolatey\lib\OpenHardwareMonitor\tools\OpenHardwareMonitor\OpenHardwareMonitor.exe"
$ShortcutFile = "$env:Public\Desktop\OpenHardwareMonitor.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

# Powertoys
# Enable the following sections: 
## PowerToys Run
## Advanced Paste
## Color Picker
## Keyboard Manager
## Find My Mouse
## Always On Top
## Image Resizer
## Peek
## PowerRename
## Screen Ruler
## Text Extractor
## Shortcut Guide
## Workspaces
# Replace AutoHotkey by:
# * Remap a key > Caps Lock -> Esc
# * Remap a shortcut > Ctrl+H -> Backspace

# PuTTY
## To set up login with ssh keys
# * Run puttygen.exe
#	* Generate a new key.
#	* Save public and private key to file to ~/.ssh/identity_files/
#  * Configure a puTTY profile
#	* Session:
#		* Enter host name and profile name
#	* Window > Apparence > select font; get a powerlinefont from https://github.com/powerline/fonts
#	* Connection:
#		* Data: Enter name for "Auto-login username"
#		* SSH
#			* "Remote command": tmux attach || tmux new-session
#			* > Auth: Select "Private key file for authentication" and chose the private .ppk file.
## Solarized
# Edit .reg file and insert name of my session on line 3, then run the file.
# https://github.com/altercation/solarized/tree/master/putty-colors-solarized
#
## Set up remote
# Open the public key saved, concatenate all lines in the middle and prepend "ssh-rsa " and upload it to server's authorized_keys



# Logitech F710 Gaming Pad
# The official drivers from
# https://support.logi.com/hc/en-us/articles/360023465553-Logitech-Wireless-Gamepad-F710-Technical-Specifications
# will work with D mode (DirectX) only. To get the more modern Xinput to work, we must use Xbox 360 driver as the driver is not updated for windows 10.
# Reference: https://www.reddit.com/r/Windows10/comments/3f0y3j/logitech_f710_driver/
# Open Device Manager > right click on your unknown F710 device > Update Driver >  "Browse my computer > "Let me select from a list" > find Xbox 360 Controllers on the list > select "Xbox 360 Controller for Windows" >  "Use driver anyway" if you get a warning. This should do the trick.
# }





# Windows Settings {
# =System
# ==Display
# * Set extended dual screen.
# * Enable Light Light > Night Light settings > Enable from Sunset to sunrise.
# ** This can be toggled in the right bar quick-settings.

# ==Power & sleep
# * Never turn off computer on AC

# ==Battery
# * Check "Turn battery save on automatically if my batter falls below" 20%, and "lower screen brightness".

# ==Clipboard
# * Enable "Clipboard history"

# ==About
# * Rename PC
# * Click "System Info", in the new window in the left menu click "System Protection". Configure 10% of C:// drive for restore points and create a first restore point.

# =Devices
# ==Mouse
# * Set lines to scroll to 20
# ==Bluetooth
# * Turn off bluetooth.
# ==Keyboard
# * Advanced Keyboard Settings > check "Use the desktop language bar when it's available"

# =Network & Internet
# ==Wi-Fi
# * Disable Paid Wi-Fi services

# =Personalization
# ==Colors==
# * Set dark mode
# ==Lock screen
# * Screen saver settings > Check "On, resume display logon screen".

# ==Themes
# * Desktop icon settings > check: Computer, User's files

#  ==Start
# * Disable Show more tiles & Occasionaly show suggestions in Start

#  ==Taskbar
# * Enable "use small taskbar buttons
# * Select which icons appear on the taskbar > add Flux
# * Disable "Show contacts on taskbar".


# =Apps
# ==Apps & features
# * Uninstall all crap apps.


# =Accounts
#  ==Your info
# * Verify your identity on this PC.


# =Time & language
# ==Date & time
# * Check "Set time zone automatically"

# =Region
# * Country: ..
# * Regional format: English (United States)
# * Click "Change date formats" > set everything to ISO8601.
# =Langauge
# * Add English US, Swedish and German.
# }

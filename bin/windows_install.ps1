# Install script for my Windows setup.
# Run this in an administrative prompt (for chocolately).
# To download-and-execute:
# $ iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/windows_install.ps1')

# Modeline {
#	vi: foldmarker={,} filetype=sh foldmethod=marker foldlevel=0: tabstop=4 shiftwidth=4:
# }


# Scoop {
# CLI developer programs. http://scoop.sh/
set-executionpolicy remotesigned -s cu
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

$scoop_prgs =
"7zip " +
"ack " +
"concfg " +
"cowsay " +
"ctags " +
"curl " +
"dig " +
"file " +
"gdb " +
"git " +
"grep " +
"latex " +
"make " +
"octave " +
"openssh " +
"patch " +
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
concfg import solarized small

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

$choco_apps =
"7zip " +
"autohotkey " +
"bleachbit " +
"cygwin " +
"discord" +
"deluge " +
"ditto " +
"f.lux " +
"firefox " +
"flashplayerplugin " +
"git " +
"googlechrome " +
"javaruntime " +
"libreoffice " +
"putty " +
"skype " +
"spotify " +
"steam " +
"sumatrapdf " +
"vim " +
"vlc " +
"whatsapp " +
"windirstat " +
"winscp " +
""

$choco_apps_additional =
"crashplan" +
"dropbox " +
"virtualclonedrive " +
""

# Whatsapp
# Is installed in %USER%\AppData\Local\Whatsapp, make a shortcut to the desktop self.


Invoke-Expression "choco install $choco_apps"
#Invoke-Expression "choco install $choco_apps_additional"

# Upgrade system with
# $ choco upgrade all

# }


# Manually install {
# * Drivers. For Thinkpad, download  http://pcsupport.lenovo.com/de/en/products/Laptops-and-## netbooks/ThinkPad-T-Series-laptops/ThinkPad-T430/downloads)
# * Lenovo ThinkVantage System Update utility, 
# * Lenovo Power Manager Driver
# * Lenovo Vantage (avilable from Microsoft Store too).
# * Intel HD Graphics Driver for Windows 10


# * Denon PMA-50 (amplifier) USB audio drivers: https://usa.denon.com/us/product/hifi/amplifiers/pma50
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
# }



# Configuration {

# Set up dotfiles. See https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
# Do this in git-bash!
# git-bash$ ssh-keygen -t rsa -C "erikw@$HOSTNAME"
# git-bash$ eval $(ssh-agent -s)
# git-bash$ ssh-add ~/.ssh/id_rsa
# Copy ~/.ssh/id_rsa.pub to Github profile
# git-bash$ git clone git@github.com:erikw/dotfiles.git ~/.dotfiles
# git-bash$ cd ~/.dotfiles
# git-bash$ git checkout -b local
# git-bash$ git config --global user.name "Erik Westrup"
# git-bash$ git config --global user.email erik.westrup@gmail.com
#
# Because bin/dfm does not work on Windows (infinite recursions), instead in a privilegied powershell install some symlinks:
# pwrshl$  New-Item -Path ~/.vimperatorrc -ItemType SymbolicLink -Value ~/.dotfiles/.vimperatorrc
# pwrshl$  New-Item -Path ~/.gitconfig -ItemType SymbolicLink -Value ~/.dotfiles/.gitconfig
 


# Taskbar (right click on)
# * Cortana > show Cortana icon.


# Start menu
# * Remove all crap.

# Create link to User's folder in the taskbar:
# 1. Right click on the desktop > New > Shortcuts
# 2. Enter destination "explorer shell:UsersFilesFolder"
# 3. Enter the user's name as name.
# 4. Drag the shortcut to the task bar.
# 5. Delete the shortcut from the desktop.

# Windows explorer
# * View > Options > Change folder & view options > view
# - check: Display full path in the title bar
# - check: Show hidden files, folders, and drives
# - uncheck: Hide extentions for known file types


# CTRL+ALT+ESC > Startup, disable all but the essentials.

# * Create folders in My Documents: tmp, doc, bin, pub

# AutoHotkey
# * Press Win+R and type "shell:Startup"
# * Make a shortcut from within this folder to ~/.dotfiles/.windows/AutoHotkey.ahk 


# Ditto
# * Right click on taskbar icon > Options
# * General > Past entries expires after: 1 day
# * Keyboard Shortcuts > Activate Ditto: Ctrl + Shift + Insert


# Vimperator:
cp ~/.dotfiles/.vimperatorrc ~/


# Linux, OSX and sane OSes store and interpret the hwclock as UTC time, while Windoze insists on it being in the local timezone...
# Fix this by setting a new regedit flag (run in privilegied powershell):
# Ref: http://lifehacker.com/5742148/fix-windows-clock-issues-when-dual-booting-with-os-x
# Ref: http://stackoverflow.com/questions/26719206/powershell-create-registry-path-one-liner
New-ItemProperty -Path Registry::HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation -Name RealTimeIsUniversal -Value 1 -Force | Out-Null


# PuTTY
# To set up login with ssh keys
# * Run puttygen.exe
# 	* Generate a new key.
# 	* Save public and private key to file.
#  * Configure a puTTY profile
#  	* Session:
#  		* Enter host name and profile name
#  	* Connection:
#  		* Data: Enter name for "Auto-login username"
#  		* SSH
#  			* "Remote command": tmux attach || tmux new-session
#  			* > Auth: Select "Private key file for authentication" and chose the private .ppk file. 
#
# }





# Windows Settings {
# =System
# ==Display
# * Set extended dual screen.

# ==Apps & features
# * Uninstall all crap apps.

# ==Power & sleep
# * Never turn off computer on AC

# ==Battery
# * Check "Turn battery save on automatically if my batter falls below" 20%, and "lower screen brightness".

# === About
# * Rename PC
# * Click "System Info", in the new window in the left menu click "System Protection". Configure 10% of C:// drive for restore points and create a first restore point.

# =Devices
# ==Bluetooth
# *Turn off bluetooth.

# =Network & Internet
# ==Wi-Fi
# * Disable Paid Wi-Fi services

# =Personalization
# ==Lock screen
# * Screen saver settings > Check "On, resume display logon screen".

# ==Themes
# * Desktop icon settings > check: Computer, User's files

#  ==Start
# * Disable Show more tiles & Occasionaly show suggestions in Start

#  ==Taskbar
# * Enable "use small taskbar buttons
# * Select which icons appear on the taskbar


# =Accounts
#  ==Your info
# * Verify your identity on this PC.


# =Time & language
# ==Date & time
# * Check "Set time zone automatically"
# * Change date and time formats, to ISO8601
# * Additonal date, time & regional settings > Region > Formats tab > Additional settings... > Time tab > change "h" to "H"s to make 24h time.

# =Region & langauge
# * Add English US, Swedish and German.
# }

#!/usr/bin/env sh
# Configure macOS to my linking
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=8:
# }



if [ $# -ne 1 ]; then
	echo "Provide computer hostname to set as argument" >&2
	exit 1
fi
new_hostname=$1


set -er

# Change screenshot destination from Desktop to something sane.
mkdir -p $HOME/media/images/screenshots
defaults write com.apple.screencapture location $HOME/media/images/screenshots

# Dim hidden apps (CMD+H) in the dock.
defaults write com.apple.Dock showhidden -boolean yes; killall Dock

# Show hidden files in Finder.
#defaults write com.apple.finder AppleShowAllFiles YES; killall Finder

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable locate(1).
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
# Build its database.
# Needs to cd / nowadays, otherwise gives errors.
#sudo /usr/libexec/locate.updatedb
sudo -s -- <<EOF
cd /
echo "Running locate.updatedb; it will take a while..."
/usr/libexec/locate.updatedb
EOF

# Make zsh default shell.
#chsh -s $(which zsh)
chsh -s /bin/zsh

# Set computers hostname.
sudo scutil --set HostName $new_hostname


# Allow apps to be installed from anywhere (System Preferences > Security & Privacy).
sudo spctl --master-disable

# Make the cursor speed even faster than possible in System Preferences.
# Reference: https://stackoverflow.com/questions/4489885/how-can-i-increase-the-cursor-speed-in-terminal
defaults write nsglobaldomain keyrepeat -int 0


# Allow a sudo session to last 5 minutes.
sudo sh -c 'echo Defaults timestamp_timeout=5 > /etc/sudoers.d/my_settings'

# Hide default un-hidable folders in home directory from Finder.
# Reset with $ chflags nohidden <dir>
chflags hidden ~/Documents
chflags hidden ~/Downloads
chflags hidden ~/Movies
chflags hidden ~/Music
chflags hidden ~/Pictures
chflags hidden ~/Public


# Add two space separators in dock, to organize icons to correspond to which monitor I want them to be open on. Let them be order by the Spaces order too.
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
killall Dock


# Install iTerm2 shell integration
# Reference: https://www.iterm2.com/documentation-shell-integration.html
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

# Optional: keep network connections alive during sleep
# Reference: https://gist.github.com/jyore/aae1d0e6e482b4d152a4bcf5b5749eed
#sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs DisconnectOnLogout

# System Preferences {
#
# General
# * Set Dark theme

# Desktop & Screensaver
## Screensaver
# * Set Hot corners:
## upper left: Application Windows
## right upper: Mission Control
## lower left: Desktop
## lower right: applications # nope, very annoyting if having monitor to the right. Keep Launchapd in dock instead.

# Dock
# * Uncheck "Show recent applications in Dock"


# Mission Control
# * Unckeck "Automatically rearrange Spaces based on most recent use"


# Language & Region
## Advanced
### General
# * Currencty: Euro
# * Measurement units: Metric
### Dates
# * Update the "Full" format to include the week number: <day>, <dayno> <month>, W<weekno>, <year>. Now the week will be visible when clicking the clock in the macOS menubar. Reference: https://www.456bereastreet.com/archive/201104/week_numbers_in_mac_os_x/


# Security & Privacy
# * Enable FileVault, with recovery key.
# * Turn on firewall. Turn on "Block all incoming connections"

# Notifications
# * Check "Turn on Do Not Disturbe: When the display is sleeping", to not leak notifications.
# * Uncheck "Show notification on lock screen" for all apps, to not leak notifications.


# Keyboard
## Keyboard
# * Make Delay Until Repeat short
# * Make Key Repeat fast
### Modifier Keys
# * Turn off backlit after 5m
# * Check "Use F1, F2,.. as standard function keys
# * Modifier Keys
#	 * For internal keyboard:
#	    - Set Caps Lock -> Escape
#	 * For external keyboard,
#	    - Set Caps Lock -> Escape
#	    (unless the keyboard is an Apple keyboard or has a "mac-switch" toggle)
#	    - Set Option -> Command
#	    - Set Command -> Option
## Input Sources
# * Add US, Swedish & German. Check "Show Input menu in menu bar".
## Shortcuts
# * Go to Input Sources: Enable shortcuts for cycling input sources forward with CTRL+SHIFT+Space and backwards CTRL+ALT+SHIFT+Space.
# * Go to Mission Control:
# 1. Set shortcut for showing notificatons menu to F13(Print screen).
# 2. Enable shortcuts Ctrl+[1-5] for switching to Desktops.
## Text
# * Click "Spelling" dropdown >  chose "Set up" > uncheck British English and check US English.


# Mouse
# * Uncheck "Scroll Direction: Natural. NOPE use scroll-reverser instead.


# Trackpad
## Point & Click
# * Check "Tap to click"
## More Gestures
# * Check App Expose


# Sound
# * Check "Show volume in menu bar"


# iCloud
# * Login and enable


# Internet Accounts
# * Add Google account to get: Calendar, Contacts, mail etc.

# Software Update
# * Check "Automatically keep my Mac up to date".

# Bluetooth
# Turn off bluetooth.

# Users & Groups
# * Drag`n'drop a picture of me on to my profile.

# Date & Time
## Clock
# * Check "Show date"



# Sharing
# Set "Computer Name"


# }


# Finder {
# * Remove crap folders from sidebar
# * Add
#  - ~/dl/
#  - ~/tmp/
#  - ~/media/images/screenshots/
#  - Desktop
#  - Applicatons
#  - /tmp
#
#
# }


# * Battery icon in menu bar > Show Percentages.

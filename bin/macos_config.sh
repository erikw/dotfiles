#!/usr/bin/env sh
# Configure macOS to my linking
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=8:
# }

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
/usr/libexec/locate.updatedb
EOF

# Make zsh default shell.
#chsh -s $(which zsh)
chsh -s /bin/zsh

# Set computers hostname. UDPATE NAME HERE before executing.
sudo scutil --set HostName $USER-computer-xyz


# ALlow apps to be installed from anywhere (System Preferences > Security & Privacy).
sudo spctl --master-disable

# Make the cursor speed even faster than possible in System Preferences.
# Reference: https://stackoverflow.com/questions/4489885/how-can-i-increase-the-cursor-speed-in-terminal
defaults write NSGlobalDomain KeyRepeat -int 0


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


# Add a space separator in dock, to organize icons to correspond to which monitor I want them to be open on. Let them be order by the Spaces order too.
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'


# Optional: keep network connections alive during sleep
# Reference: https://gist.github.com/jyore/aae1d0e6e482b4d152a4bcf5b5749eed
#sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs DisconnectOnLogout

# System Preferences {

# Keyboard
## Keyboard
# * Make Time to adjust short
# * Make Key Repeat fast
## Modifier Keys
# 1. Go to Preferences > Keyboard > Modifier Keys
# 2. Check "Use F1, F2,.. as standard function keys
# 3. For internal keyboard:
#    - Set Caps Lock -> Escape
# 4. For external keyboard,
#    - Set Caps Lock -> Escape
#    (unless the keyboard is an Apple keyboard or has a "mac-switch" toggle)
#    - Set Option -> Command
#    - Set Command -> Option

## Input Sources
# * Add Swedish & German. Check "Show Input menu in menu bar".
## Shortcuts
# * Go to Input Sources: Add shortcuts for toggling with CTRL+SHIFT+Space and CTRL+ALT+SHIFT+Space.
# * Go to Mission Control:
# 1. Set shortcut for showing notificatons menu to F13(Print screen).
# 2. Enable shortcuts Ctrl+[1-5] for switching to Desktops.

## Text
# * Click "Spelling" dropdown >  chose "Set up" > uncheck British English and check US English.
#
#
# Desktop & Screensaver
## Screensaver
# * Set Hot corners:
## upper left: app windows
## right upper: spaces
## lower left: show desktop
## lower right: applications # nope, very annoyting if having monitor to the right. Keep Launchapd in dock instead.


# Mission Control
# * Unckeck "Automatically rearrange Spaces..."

# Date & Time
## Clock
# * Check "Show date"
#
#
# # Profile
# * Drag`n'drop a picture of me on to my profile.
#
# # Bluetooth
# Turn off bluetooth.
#
# Internet Accounts
# * Add Google account to get: Calendar, Contacts, mail etc.
# * Add sign in with an Apple account to use: keychain, Find my mac, Back to my mac


# Notifications
# * Check "Turn on Do Not Disturbe: When the display is sleeping", to not leak notifications.
# * Uncheck "Show notification on lock screen" for all apps, to not leak notifications.

# Sharing
# Set "Computer Name"

# Language & Region
## Advanced
### Dates
# * Update the "Full" format to include the week number: <day>, <month> <dayno>, W<weekno>, <year>. Now the week will be visible when clicking the clock in the macOS menubar. Reference: https://www.456bereastreet.com/archive/201104/week_numbers_in_mac_os_x/

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

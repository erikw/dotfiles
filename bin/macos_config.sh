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

# Disable the thumbnail preview that delays saving the screenshot to disk.
# Reference: https://apple.stackexchange.com/questions/340170/turn-off-macos-mojave-screenshot-preview-thumbnails-with-defaults-write-command
defaults write com.apple.screencapture show-thumbnail -bool FALSE

# Dim hidden apps (CMD+H) in the dock.
defaults write com.apple.Dock showhidden -boolean yes; killall Dock

# Show hidden files in Finder.
#defaults write com.apple.finder AppleShowAllFiles YES; killall Finder

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable locate(1).
# NOTE disabled in favour for findutil's GNU locate which can find dot files.
#sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
# Build its database.
# Needs to cd / nowadays, otherwise gives errors.
#sudo /usr/libexec/locate.updatedb
#sudo -s -- <<EOF
#cd /
#echo "Running locate.updatedb; it will take a while..."
#/usr/libexec/locate.updatedb
#EOF

# Make zsh default shell for local user.
# NOTE not needed since macos 10.15 Catalina. https://apple.slashdot.org/story/19/06/04/1645240/apple-replaces-bash-with-zsh-as-the-default-shell-in-macos-catalina?utm_source=rss1.0mainlinkanon&utm_medium=feed
#chsh -s $(which zsh)
#chsh -s /bin/zsh


# Set computers hostname.
sudo scutil --set HostName $new_hostname


# Allow apps to be installed from anywhere (System Preferences > Security & Privacy).
sudo spctl --master-disable

# Make the cursor speed even faster than possible in System Preferences.
# Reference: https://stackoverflow.com/questions/4489885/how-can-i-increase-the-cursor-speed-in-terminal
defaults write nsglobaldomain keyrepeat -int 0


# Allow a sudo session to last a bit longer, across terminals.
sudo sh -c " cat >/etc/sudoers.d/99_my_settings" << EOF
# Set cached password timeout in minutes.
Defaults:USER_NAME timestamp_timeout=16
# Single password cache for user.
Defaults !tty_tickets

# Command groups.
Cmnd_Alias CMDS_POWER = /sbin/halt, /sbin/shutdown, /sbin/reboot

# Let power users issue power commands.
%power ALL = NOPASSWD: CMDS_POWER
EOF


# Create power group and add user.
sudo dseditgroup -o create power
sudo dseditgroup -o edit -u $USER -p -a $USER -t user power


# Hide default un-hidable folders in home directory from Finder.
# Reset with $ chflags nohidden <dir>
chflags hidden ~/Documents
chflags hidden ~/Downloads
chflags hidden ~/Movies
chflags hidden ~/Music
chflags hidden ~/Pictures
chflags hidden ~/Public


# Add a note to /etc/host to make it easier
sudo sh -c " cat >>/etc/hosts" << EOF


# After editing this file, execute:
# $ dscacheutil -flushcache; sudo killall -HUP mDNSResponder
# Reference: https://www.tekrevue.com/tip/edit-hosts-file-mac-os-x/
EOF


# Add two space separators in dock, to organize icons to correspond to which monitor I want them to be open on. Let them be order by the Spaces order too.
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
killall Dock


# Install iTerm2 shell integration
# Reference: https://www.iterm2.com/documentation-shell-integration.html
#curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

# Optional: keep network connections alive during sleep
# Reference: https://gist.github.com/jyore/aae1d0e6e482b4d152a4bcf5b5749eed
#sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs DisconnectOnLogout


# Track /etc in git
sudo -s -- <<EOF
cd /etc
git init
touch .gitignore
git add .
git config --global user.email "$USER@HOST"
git config --global user.name "$(id -un)"
git commit -m "Initital commit"
EOF

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
## lower right: Sleep Monitors # nope, very annoyting if having monitor to the right.

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
## FileVault
# * Enable FileVault, with recovery key.
## Firewall
# * Turn on firewall. Turn on "Block all incoming connections"
# 	* NOPE turn that off, and uncheck everything and add Chrome as an expcetion to allow incoming traffic, so Videostream chromecast app works.

# Notifications
# * Check "Turn on Do Not Disturbe: When the display is sleeping", to not leak notifications.
# * Uncheck "Show notification on lock screen" for all apps, to not leak notifications.


# Display
# * Move the white menu bar to the main monitor, so notifications etc. comes on it.
# * Check "Show mirroring options in the menu bar when available".
## Night SHift
# * Schedule: Sunset to Sunrise

# Energy Saver
## Power Adapter
# * Uncheck "Enable Power Nap while plugged in", because during wake-up, cronjobs can start but will fail as power goes down soon again (happended with my restic_backup.se).

# Keyboard
## Keyboard
# * Make Delay Until Repeat short
# * Make Key Repeat fast
### Modifier Keys
# * Turn off backlit after 1 minute.
# * Check "Use F1, F2,.. as standard function keys
# * Modifier Keys
#	 * For internal keyboard:
#	    - Set Caps Lock -> Escape
#	 * For external keyboard,
#	    - Set Caps Lock -> Escape
#	    (unless the keyboard is an Apple keyboard or has a "mac-switch" toggle)
#	    - Set Option -> Command
#	    - Set Command -> Option
## Text
# * Set word expansions based on ~/doc/tech/word_expansions.txt
## Input Sources
# * Add US, Swedish & German. Check "Show Input menu in menu bar".
## Shortcuts
### Input Sources
# * Enable shortcuts for cycling input sources _backwards_ with CTRL+OPT+Space. Reason for only having forward is because of keyboard shorcut clash on SHIFT+OPT with Amethyst's cycle layout.
### Mission Control:
# * Show Notification Center: F13 (Print screen).
# * Enable shortcuts Ctrl+[1-5] for switching to Desktops.
# * Do not Distrurb on/off: Cmd+F12
#
## Text
# * Click "Spelling" dropdown >  chose "Set up" > uncheck British English and check US English.


# Mouse
# * Uncheck "Scroll Direction: Natural. NOPE use scroll-reverser app instead.
# * Set Tracking Speed to 1/2
# * Set Scrolling Speed to 3/4


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


# Accessibility
## Zoom
# * Check "Use keyboard shortcuts to zoom".
# * Select Zoom style: Picture-in-picture
# ** Options > Uncheck "Hold Ctrl+Opt to temporarily toggle zoom" as this interferece with shortcut to toggle input language, and leave mouse cursor hidden after toggling input source.

# Sharing
# Set "Computer Name"
# If want SMB file sharing: Check File Sharing, add ~/pub folder, Click Options and enable current user.


# }

# Finder {
# * Remove crap folders from sidebar
# * Add
#  - ~/doc/
#  - ~/dl/ - copy folder icon from ~/Downloads
#  - ~/tmp/
#  - ~/media/images/screenshots/
#  - Desktop
#  - Applicatons
#  - /tmp
#  * OPTIONAL: Copy icon from Downloads -> DL in CMD+i dialog.
## View
# ** Show Path Bar
# ** Show Status Bar
### Show View Options
# * First make sure to be in List view before entering this menu
# * Check "Always open in list view" > Use as default
# * Also open this diealog while being in ~/, then check "Show Library Folder". Reference: https://appletoolbox.com/unhide-access-mac-library-folder/
## Preferences
# ** General
# *** Show on desktop: connected servers
# ** Sidebar
# *** Hide things like Airdrop, iCould, Recents
#
# }

# Dock {
# * Add ~/  and ~/dl/to dock.
# * For dual monitors: For all applications in dock: Right click > Option > assign to correct monitor and desktop.
# }

# Mail.app {
# * The default keyboard shortcut for archive an email, ^+cmd+a, conflicts with Todoist. Add another one.
# 	- Reference: https://www.lifewire.com/archive-keyboard-shortcut-os-x-mail-1172749
# 	- System Preferences > Shortcuts > App Shortcuts > + >
# 		- Application: Maill.app
# 		- Menu Title: Archive
# 		- Keyboard shortcut: Opt+a
## Accounts
# * Disable iCloud
## Composing
# * Message format: plain text. NOPE use Rich Text, it's not the 90s anymore....
## Signatures
# * Add new signature "Standard".
# }

# Music.app {
## Files
# * Add music folder.
# * Uncheck "Keep music Media folder organized"
# }

# Photos.app {
## General
# * Uncheck "Copy items to the photos library"
# }

# iMessge.app {
# * Turn off associattion to my mobile phone number, so it won't steal text messages from iPhones
# Settings > Unlink my AppleID
# }

# Sidebar {
# Set up the weather widget to show current location (better to use this thant the WeatherBug tray icon consuming power and visual space)
# }

# Menubar {
# * Arrange icons so that the least important ones are to the left, as they are chopped of when space becomes to little e.g. on the laoptop screen.
# }

# Media shortcuts for external keyboard: follow instructions in ~/bin/macos_media_control/info.txt

# * Battery icon in menu bar > Show Percentages.

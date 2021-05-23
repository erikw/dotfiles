#!/usr/bin/env sh
# Configure macOS to my linking.
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=8:
# }

# CLI conf {
# Script Environment {
set -ex

# From: https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'
# Ask for the administrator password upfront
#sudo -v
# Keep-alive: update existing `sudo` time stamp until this script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
# }

# System {
# Set computers hostname.
new_hostname=
while [ -z "$new_hostname" ]; do
	echo -n "Enter new computer hostname: "
	read new_hostname
done;
sudo scutil --set HostName $new_hostname


# Add a note to /etc/host to make it easier
sudo sh -c " cat >>/etc/hosts" << EOF


# After editing this file, execute:
# $ dscacheutil -flushcache; sudo killall -HUP mDNSResponder
# Reference: https://www.tekrevue.com/tip/edit-hosts-file-mac-os-x/
EOF

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


# Allow apps to be installed from anywhere (System Preferences > Security & Privacy).
sudo spctl --master-disable

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


# Optional: keep network connections alive during sleep
# Reference: https://gist.github.com/jyore/aae1d0e6e482b4d152a4bcf5b5749eed
#sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs DisconnectOnLogout


# Track /etc in git
# NOTE skip this as it's almost only official distribution upgrades that modifies /etc on macOS.
#sudo -s -- <<EOF
#cd /etc
#git init
#touch .gitignore
#git add .
#git config --global user.email "$USER@HOST"
#git config --global user.name "$(id -un)"
#git commit -m "Initital commit"
#EOF


# }

# UI {
# Change screenshot destination from Desktop to something sane.
mkdir -p $HOME/media/images/screenshots
defaults write com.apple.screencapture location $HOME/media/images/screenshots

# Make the cursor speed even faster than possible in System Preferences.
# Reference: https://stackoverflow.com/questions/4489885/how-can-i-increase-the-cursor-speed-in-terminal
defaults write nsglobaldomain keyrepeat -int 0

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the thumbnail preview that delays saving the screenshot to disk.
# Reference: https://apple.stackexchange.com/questions/340170/turn-off-macos-mojave-screenshot-preview-thumbnails-with-defaults-write-command
defaults write com.apple.screencapture show-thumbnail -bool FALSE


# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → NOP
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Put Display to Sleep
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0

# }

# Dock {
# Dim hidden apps (CMD+H) in the dock.
defaults write com.apple.Dock showhidden -boolean yes

# Add two space separators in dock, to organize icons to correspond to which monitor I want them to be open on. Let them be order by the Spaces order too.
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Make settings take effect.
killall Dock
# }


# Other {
# iTerm2 shell integration
# Reference: https://www.iterm2.com/documentation-shell-integration.html
#curl -L https://iterm2.com/misc/install_shell_integration.sh | bash
# }

echo "Please logout or restart for all settings to take effect."
#}

# GUI conf {
# System Preferences {
# # Apple Id
## Media & Purchases
# * Free Downloads: Never Require
#
# General
# * Appearance: Auto
# * NOPE Uncheck "Close windows when quitting an app"

# Desktop & Screensaver
## Desktop
# * Add all folders in ~/media/images/wallpapers/dynamic_mac/.
#   * See https://www.dynamicwallpaper.club/docs on how to use custom dynamic images.
#   * See https://apple.stackexchange.com/questions/71070/how-to-change-desktop-wallpaper-for-all-virtual-desktops/415790#415790 on how to set wallpaper for all desktops.
## Screensaver
# * Set Hot corners:
## upper left: -
## upper right: Mission Control
## lower left: Desktop
## lower right: Put Display to Sleep

# Dock & Menu Bar
# * Uncheck "Show recent applications in Dock"
# * Show  in Menu Bar
#   - Do Not Distrub: when active
#   - Screen Mirroring: when active
#   - Display: hide in menu bar
#   - Sound: always
#   - Now Playing: when active
#   - Battery: Menu Bar, Control center. Show percentage
#   - Clock:
#   	- Uncheck Show day of the week & Show date. NOPE itsycal removed, keep defaults.
#   - Spotlight: turn off
#   - Time machine: Menu bar


# Mission Control
# * Unckeck "Automatically rearrange Spaces based on most recent use"


# Language & Region
# * Add English (US), Swedish, German
# * Set Region to Germany
## Advanced (button)
### General
# * Currencty: Euro
# * Measurement units: Metric
### Dates
# * Update the "Full" format to include the week number: <day>, <dayno> <month>, W<weekno>, <year>. Now the week will be visible when clicking the clock in the macOS menu bar. Reference: https://www.456bereastreet.com/archive/201104/week_numbers_in_mac_os_x/
# ** NOPE since macos 11 Big Sur, these settings are overriden by the Menu Bar. It's possible to modify somewhat with https://github.com/tech-otaku/menu-bar-clock but not worth it.



# Notifications
# * Turn on DnD from 00:00 to 07:00.
# * Check "Turn on Do Not Disturbe: When the display is sleeping", to not leak notifications.
# * Uncheck "Show notification on lock screen" for all apps individually, to not leak notifications.


# Security & Privacy
## FileVault
# * Enable FileVault, with recovery key.
## Firewall
# * Turn on firewall. Turn on "Block all incoming connections"
## Privacy
# * Apple Advertising > uncheck "Personalize Ads".



# Display
# * Move the white menu bar to the main monitor, so notifications etc. comes on it.
# * Check "Show mirroring options in the menu bar when available".
## Night Shift
# * Schedule: Sunset to Sunrise




# Battery
## Power Adapter
### Power Adapter
# * Sleep display after 30min
# * Uncheck "Enable Power Nap while plugged in", because during wake-up, cronjobs can start but will fail as power goes down soon again (happended with my restic_backup.se).
# 	NOPE don't uncheck this, as this prevents time machine backups from happening. Seems like there are some problems around power management and disks getting ejected automatically when sleeping the computer.
# * Uncheck "Wake for network access" as I have not use case for this.



# Keyboard
## Keyboard
# * Make Delay Until Repeat short (2nd most right value)
# * Make Key Repeat fast (fastest)
# * Turn off backlit after 1 minute.
# * Non-touchbar MPBs:
# ** Uncheck "Use F1, F2 etc. keys as standard function keys".
# * Touchbar MBPs:
# ** Press FN key to: Show F1, F2, etc Keys.
# ** Check "Use F1, F2 etc. keys as standard function keys on external keyboards"
### Customtize Control Strip (button)
# * Most-right control strip buttons: Play/pause, Volume Slider, Mute, DnD
# * To the expanded control strip: replace Siri with Sleep button to the very far right.
### Modifier Keys
# ** NOTE if need to swap fn and ctrl on internal keyboard, use karabiner-elements.
# * For internal keyboard:
#    - Set Caps Lock -> Escape
# * For external keyboard,
#    - Set Caps Lock -> Escape
#    (unless the keyboard is an Apple keyboard or has a "mac-switch" toggle):
#    - Set Option -> Command
#    - Set Command -> Option
## Text
# * Set word expansions based on ~/doc/tech/word_expansions.txt
# * Optionally change Spelling from "Automatic by Language" to "US English", as in some apps like Slack it selects Britishs spelling instead of US.
## Input Sources
# * Add US, Swedish & German. Check "Show Input menu in menu bar".
# * Click "Spelling" dropdown >  chose "Set up" > uncheck British English and check US English. NOPE let it be "Automatic by Language"
## Shortcuts
### Input Sources
# * Enable shortcuts for cycling input sources _backwards_ ("Select the previous input source") with CTRL+OPT+Space. Reason for only having forward is because of keyboard shorcut clash on SHIFT+OPT with Amethyst's cycle layout.
### Mission Control:
# * Show Notification Center: Cmd+F11
# * Enable shortcuts Ctrl+[1-5] for switching to Desktops. (Need to open 5 spaces for this to show up)
# * Do not Distrurb on/off: Cmd+F12
## Text


# Mouse
# * Uncheck "Scroll Direction: Natural. NOPE use scroll-reverser app instead, to have natural scroll with trackpad and normal scroll with external mouse.
# * Set Tracking Speed to 1/2
# * Set Scrolling Speed to 3/4


# Trackpad
## Point & Click
# * Check "Tap to click"
## More Gestures
# * Check App Expose


# Sound
# * Uncheck "Play sound on startup"
# * Check "Show volume in menu bar"

# Internet Accounts
# * Add Google account to get: Calendar, Contacts, mail etc.

# Software Update
# * Check "Automatically keep my Mac up to date".

# Bluetooth
# Check "Show Bluetooth in menu bar"

# Users & Groups
# * Drag`n'drop a picture of me on to my profile.

# Date & Time
## Clock
# * Check "Show date"


# Accessibility
## Zoom
# * Check "Use keyboard shortcuts to zoom".
# * Select Zoom style: Picture-in-picture
# ** Advanced > Controls tab > Uncheck "Hold Ctrl+Opt to temporarily toggle zoom" as this interferece with shortcut to toggle input language, and leave mouse cursor hidden after toggling input source.


# Sharing
# Set "Computer Name"
# If want SMB file sharing: Check File Sharing, add ~/pub folder, Click Options and enable current user.


# }

# Finder {

## View
# ** Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true
# ** Show Status Bar
defaults write com.apple.finder ShowStatusBar -bool true
### Show View Options
# * First make sure to be in List view before entering this menu
# * Check "Always open in list view" > Use as default
# * Also open this diealog while being in ~/, then check "Show Library Folder". Reference: https://appletoolbox.com/unhide-access-mac-library-folder/
## Preferences
# ** General
# *** Show on desktop: connected servers, disks
# *** New Finder window shows: ~/
# ** Sidebar
# *** Hide things like Airdrop, iCould, Recents
# View > Customize Control Strip > Add "New Folder" shortcut



## Misc
# * Remove crap folders from sidebar
# * Add
#  - ~/doc/
#  - ~/dl/ - copy folder icon from ~/Downloads
#  - ~/tmp/
#  - ~/media/images/screenshots/
#  - Desktop
#  - Applicatons
#  - /tmp
#  - /Volumes/toshiba_music/daw/plugins/
#  - /Volumes/toshiba_music/music/samples/
#  * OPTIONAL: Copy icon from Downloads -> DL in CMD+i dialog.

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files in Finder.
#defaults write com.apple.finder AppleShowAllFiles YES

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false


# Hide default un-hidable folders in home directory from Finder.
# Reset with $ chflags nohidden <dir>
chflags hidden ~/Documents
chflags hidden ~/Downloads
chflags hidden ~/Movies
#chflags hidden ~/Musi
chflags hidden ~/Pictures
chflags hidden ~/Public
# But do show the user Library
chflags nohidden ~/Library

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true


# Make settings take effect.
killall Finder
# }

# Menu Bar {
# * On the notification/widget dropdown (click on clock), keep the following widgets
# ** Calendar (m)
# ** Weather (m)
# }

# Dock {
# * Add ~/ (Stack: list)  and ~/dl/ (Stack: grid) to dock.
# * For dual monitors: For all applications in dock: Right click > Option > assign to correct monitor and desktop.
# }

# Mail.app {
# * Drag my Gmail account to the top in the mailboxes left side list and collapse all other.
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

# App Store {
# * Uncheck "In-App Ratings & Reviews"
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

# Desktop {
# * Right click > Sort By > Check "Snap to grid".
# }

# Terminal.app {
#Profiles
## Shell
# * When the shell exists: close if the shell exited cleanly
# }

# Media shortcuts for external keyboard: follow instructions in ~/bin/macos_media_control/info.txt
# }

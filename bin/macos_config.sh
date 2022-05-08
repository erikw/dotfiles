#!/usr/bin/env sh
# Configure macOS to my linking.
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=4:
# }

# Notes {
# Find out key and values for settings by:
# 1. $ defaults read > before
# 2. Change a setting e.g. in System Preferences
# 3. $ defaults read > after
# 4. $ vimdiff before after
# Reference: https://pawelgrzybek.com/change-macos-user-preferences-via-command-line/
# }

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


# Create power group and add user for sudo rule above.
sudo dseditgroup -o create power
sudo dseditgroup -o edit -u $USER -p -a $USER -t user power

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

# System Preferences {
# Apple ID {
## Media & Purchases
# * Free Downloads: Never Require
# }

# General {
# * Appearance: Auto
# * NOPE  Uncheck "Close windows when quitting an app"
# }

# Desktop & Screensaver {
## Desktop
# * Add all folders in ~/media/images/wallpapers/dynamic_mac/.
#   * See https://www.dynamicwallpaper.club/docs on how to use custom dynamic images.
#   * See https://apple.stackexchange.com/questions/71070/how-to-change-desktop-wallpaper-for-all-virtual-desktops/415790#415790 on how to set wallpaper for all desktops.
## Screensaver
# * Check "Show with clock"
###  Hot Corners:
# Reference: https://blog.jiayu.co/2018/12/quickly-configuring-hot-corners-on-macos/
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
# * Top Left corner: NOP
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
# * Top Right corner: Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
# * Bottom Left corner: Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
# * Bottom Right corner: Put Display to Sleep
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0
# }

# Dock & Menu Bar {
# * Uncheck "Show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false
* Prevent accidential change of dock size or position by locking
defaults write com.apple.Dock position-immutable -bool true
# * Control Centre:
# - Wi-Fi: uncheck
# - Bluetooth: uncheck
# - AirDrop: uncheck
# - Do Not Distrub: when active
# - Keyboard Brightness: uncheck
# - Screen Mirroring: when active
# - Display: uncheck
# - Sound: always
# - Now Playing: when active
# * Other modules:
# - Accessibility Shourtcuts: uncheck all
# - Battery: Menu Bar, Control center. Show percentage
# - Fast User Switching: uncheck all
# * Menu Bar Only
# - Clock: nop
# - Spotlight: uncheck
# - Siri: uncheck
# - Time machine: Show in Menu Bar
# Dock misc {
# * Add ~/ (Stack, List)  and ~/dl/ (Stack, Grid) to dock.
# * For dual monitors: For all applications in dock: Right click > Option > assign to correct monitor and desktop.

# Dim hidden apps (CMD+H) in the dock.
defaults write com.apple.Dock showhidden -boolean yes

# Add two space separators in dock, to organize icons to correspond to which monitor I want them to be open on. Let them be order by the Spaces order too.
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# }
# }

# Mission Control {
# * Unckeck "Automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false
# }

# Language & Region {
# * Add English (US), Swedish, German
defaults write NSGlobalDomain AppleLanguages -array en-us sv-se de-de
# * Region: Germany
defaults write NSGlobalDomain AppleLocale en_DE
# }

# Notifications {
# * Turn of Do Not Disturb:
#  - From 22:00 to 08:00
#  -  When the display is sleeping
#  -  When mirroring to TVs and projectors
# * Uncheck "Show notification on lock screen" for all apps individually, to not leak notifications.
# }

# Security & Privacy {
## General
# * Allow apps downloaded from: Anywhere
sudo spctl --master-disable
# * Check: Require password <immediately> after sleep or screen saver begins
## FileVault
# * Enable FileVault, with recovery key.
## Firewall
# * Turn on firewall.
# Reference: https://superuser.com/a/1641741
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
# * NOPE Turn on "Block all incoming connections"
# Reference: https://superuser.com/a/1357550
# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on
## Privacy
# * Apple Advertising > uncheck "Personalize Ads".
# }

# Display {
# * Move the white menu bar to the main monitor, so notifications etc. comes on it.
# * Check "Show mirroring options in the menu bar when available".
## Night Shift
# * Schedule: Sunset to Sunrise
# }

# Battery {
## Battery
# * Turn display off after: 5 min
## Power Adapter
# * Turn display off after: 60 min
# * Check "Prevent your mac from automatically sleeping when the display is off"
# }

# Keyboard {
## Keyboard
# * Key Repeat: fastest
#  Could make it even faster than allowed in System Preferences by setting to 0 or 1, but that's too fast. Reference: https://stackoverflow.com/a/4490124
defaults write NSGlobalDomain KeyRepeat -int 2
# * Delay Until Repeat: short (2nd most right value)
defaults write -g InitialKeyRepeat -int 25
# * Turn off backlit after 1 minute.
# Non-touchbar MPBs {
# ** Uncheck "Use F1, F2 etc. keys as standard function keys".
# }
# Touchbar MBPs {
# ** Press FN key to: Show F1, F2, etc Keys.
# ** Check "Use F1, F2 etc. keys as standard function keys on external keyboards"
### Customtize Control Strip (button)
# * Most-right control strip buttons: Play/pause, Volume Slider, Mute, DnD
# * To the expanded control strip: replace Siri with Sleep button to the very far right.
# }
### Modifier Keys
# ** NOTE if need to swap fn and ctrl on internal keyboard, use karabiner-elements.
# * For internal keyboard:
#    - Set Caps Lock -> Escape
# * For external keyboard:
#    - Set Caps Lock -> Escape
#    (unless the keyboard is an Apple keyboard or has a "mac-switch" toggle):
#    - Set Option -> Command
#    - Set Command -> Option
## Text
# * Set word expansions based on ~/doc/tech/word_expansions.txt
# * Spelling: Automatic by Language
# * Click the "Spelling" dropdown > choose "Set up" > uncheck British English and check US English.
## Shortcuts
### Mission Control:
# * Show Notification Center: Cmd+F11
# * Enable shortcuts Ctrl+[1-5] for switching to Desktops. (Need to open 5 spaces for this to show up)
# * Do not Distrurb on/off: Cmd+F12
### Input Sources
# * Enable shortcuts for cycling input sources _backwards_ ("Select the previous input source") with CTRL+OPT+Space.
# * Check "Select the *previous* input source: ctrl+opt+space.
# * Uncheck "Select next source"
# Reason: keyboard shorcut clash on SHIFT+OPT with Amethyst's cycle layout.
## Input Sources
# * Add US, Swedish & German. NOTE should have been automatically added after adding these languages in Language & Region (AppleLanguages)
# * Check "Show Input menu in menu bar".
# }

# Mouse {
# * Uncheck "Scroll Direction: Natural. NOPE use scroll-reverser app instead, to have natural scroll with trackpad and normal scroll with external mouse.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# For setting a new speed, easiest is to set the value in System Preferences, then read desired value $(defaults read -g com.apple.mouse...)
# * Tracking Speed: 1/2
defaults write -g com.apple.mouse.scaling 0.875
# * Scrolling speed: 3/4
defaults write -g com.apple.scrollwheel.scaling 0.75
# * Double-click speed: 3/4
defaults write -g com.apple.mouse.doubleClickThreshold 0.8

# }

# Trackpad {
## Point & Click
# * Check "Tap to click"
defaults -currentHost write -globalDomain com.apple.mouse.tapBehavior -int 1
## More Gestures
# * Check App Expose
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
# }

# Sound {
# * Uncheck "Play sound on startup"
# }

# Printers & Scanners {
# Automatically quit printer app once the print jobs complete.
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# }

# Internet Accounts {
# * Add Google account to get: Calendar, Contacts, mail etc.
# }

# Software Update {
# * Check "Automatically keep my Mac up to date".
# }

# Bluetooth {
# }

# Users & Groups {
# * Drag`n'drop a picture on to my profile.
# }

# Date & Time {
# }

# Accessibility {
## Zoom
# * Check "Use keyboard shortcuts to zoom".
# * Select Zoom style: Picture-in-picture
# ** Advanced > Controls tab > Uncheck "Hold Ctrl+Opt to temporarily toggle zoom" as this interferece with shortcut to toggle input language, and leave mouse cursor hidden after toggling input source.
# }

# Sharing {
# * Set "Computer Name". Unfortunately different from system hostname (below).
# * Set computers hostname.
new_hostname=
while [ -z "$new_hostname" ]; do
	echo -n "Enter new computer hostname: "
	read new_hostname
done;
sudo scutil --set HostName $new_hostname


# * If want SMB file sharing:
#  - Check File Sharing
#  - add ~/pub folder
#  - Click Options and enable current user
# }

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
# Four-letter codes for the view modes: `icnv`, `Nlsv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# * Also open this dialog while being in ~/, then check "Show Library Folder". Reference: https://appletoolbox.com/unhide-access-mac-library-folder/
chflags nohidden ~/Library
## Preferences
### General
# *** Show on desktop: connected servers, disks
#defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# *** New Finder window shows: ~/
#defaults write com.apple.finder NewWindowTargetPath -string "file:///$HOME/"  # Does not work!
### Tags
# * Hide all
### Sidebar
# *** Hide: Airdrop, Documents, Downloads, Movies, Music, Pictures, Recent Tags
# View > Customize Control Strip > Add "New Folder" shortcut
### Advanced
# * Check: Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# * Uncheck: Show warning before changing an extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# * Keep folders on top: In windows when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true



## Misc
# * Sidebar Favourites, add to make it
# - ~/
# - ~/.dropbox-data/Dropbox/
# - ~/Desktop/
# - ~/doc/
# - ~/dl/
# - ~/media/
# - ~/media/images/screenshots/
# - ~/media/music/production/
# - ~/src/github.com/
# - ~/tmp/
# - ~/.config/finder/---------/
# - /Applications
# - /private/tmp
# - /Volumes/toshiba_music/daw/plugins/
# - /Volumes/toshiba_music/music/samples/
# * OPTIONAL: Copy icon from ~/Downloads to ~/dl in cmd+i dialog.


# Show hidden files in Finder.
#defaults write com.apple.finder AppleShowAllFiles YES

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Hide default un-hidable folders in home directory from Finder.
# Reset with $ chflags nohidden <dir>
chflags hidden ~/Documents
chflags hidden ~/Downloads
chflags hidden ~/Movies
#chflags hidden ~/Music
chflags hidden ~/Pictures
chflags hidden ~/Public
# }

# Menu Bar {
# * On the notification/widget dropdown (click on clock), keep the following widgets
#  - Calendar (m)
#  - Weather (m)
# }

# Mail.app {
# * Drag my Gmail account to the top in the mailboxes left side list and collapse all other.
# * Break out the  Archive button with space on both sides, to not misclick delete button.
# * The default keyboard shortcut for archive an email, ctrl+cmd+a, conflicts with Todoist. Add another one.
#	- Reference: https://www.lifewire.com/archive-keyboard-shortcut-os-x-mail-1172749
#	- System Preferences > Shortcuts > App Shortcuts > + >
#		- Application: Maill.app
#		- Menu Title: Archive
#		- Keyboard shortcut: Opt+a
## General
# * Downloads folder: ~/dl
## Accounts
# * Disable iCloud
## Composing
# * Message format: plain text. NOPE use Rich Text, it's not the 90s anymore....
## Signatures
# * Add new signature "Standard".
## Privacy
# * Turn off everything
# }

# Calendar.app {
# * Sidebar: uncheck "Siri Suggestions" calendar
## General:
# * Default calendar: my default Google calendar
## Accounts
# * Disable iCloud account
### Google
# * Refresh Calendars: every 5 minutes
## Alerts (for Google)
# * Events: None
# * All Day Events: None
# * Birthdays: None
## Advanced
# * Check "Show events in year view"
# * Check "Show week numbers"
# }

# Music.app {
## Files
# * Add music folder.
# * Uncheck "Keep music Media folder organized"
## Advanced
# * Check "Automatically update artwork"
# }

# Photos.app {
## General
# * Uncheck "Copy items to the photos library"
# }

# App Store {
# * Uncheck "In-App Ratings & Reviews"
# }

# Terminal.app {
#Profiles
## Shell
# * When the shell exists: close if the shell exited cleanly
# }

# Archive Utill.app {
# * Uncheck "Reveal expanded items in Finder"
# }

# Misc {
# Change screenshot destination from Desktop to something sane.
mkdir -p $HOME/media/images/screenshots
defaults write com.apple.screencapture location $HOME/media/images/screenshots

# Disable the thumbnail preview that delays saving the screenshot to disk.
# Reference: https://apple.stackexchange.com/questions/340170/turn-off-macos-mojave-screenshot-preview-thumbnails-with-defaults-write-command
defaults write com.apple.screencapture show-thumbnail -bool FALSE


# iTerm2 shell integration
# Reference: https://www.iterm2.com/documentation-shell-integration.html
#curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

# Media shortcuts for external keyboard: follow instructions in ~/bin/macos_media_control/info.txt

# Move any window with ctrl+cmd+click+drag, like typical Linux WMs.
# Ref: https://mmazzarolo.com/blog/2022-04-16-drag-window-by-clicking-anywhere-on-macos/
defaults write -g NSWindowShouldDragOnGesture -bool true
# }

killall Dock Finder
echo "Please logout or restart for all settings to take effect."

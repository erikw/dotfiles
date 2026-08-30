#!/usr/bin/env bash
# Configure macOS to my liking.
# NOTE make sure this script is idempotent!
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0
# }

# Notes {
# Find out key and values for settings by:
# 1. $ defaults read > before
# 2. Change a setting e.g. in System Settings
# 3. $ defaults read > after
# 4. $ vimdiff before after
# Reference: https://pawelgrzybek.com/change-macos-user-preferences-via-command-line/
# }

# Script Environment {
set -o errexit
set -o nounset
set -o pipefail
set -o xtrace
config_marker="#dotfiles-macos_config"
tmp_dir=$(mktemp -d)
sudo_keepalive_pid=
sudo_initialized=false

cleanup() {
	if [ -n "$sudo_keepalive_pid" ]; then
		kill "$sudo_keepalive_pid" >/dev/null 2>&1 || true
	fi
	rm -rf "$tmp_dir"
}

trap cleanup EXIT

# Start a sudo session only when a privileged change is actually needed.
ensure_sudo_session() {
	if ! $sudo_initialized; then
		sudo -v
		while true; do
			sudo -n true
			sleep 60
			kill -0 "$$" || exit
		done 2>/dev/null &
		sudo_keepalive_pid=$!
		sudo_initialized=true
	fi
}

# Run a command via sudo, initializing the shared sudo keepalive lazily.
run_with_sudo() {
	ensure_sudo_session
	sudo "$@"
}

# Return success when a defaults array already contains the given string value.
defaults_array_contains() {
	local domain=$1
	local key=$2
	local value=$3

	defaults read "$domain" "$key" 2>/dev/null | grep -Fq "\"${value}\""
}

# Ensure every dictionary component in a PlistBuddy path exists before setting leaf values.
ensure_plist_dict_path() {
	local plist=$1
	local path=$2
	local current_path=
	local part=

	IFS=':' read -r -a path_parts <<<"${path#:}"
	for part in "${path_parts[@]}"; do
		current_path="${current_path}:${part}"
		if ! /usr/libexec/PlistBuddy -c "Print ${current_path}" "$plist" >/dev/null 2>&1; then
			/usr/libexec/PlistBuddy -c "Add ${current_path} dict" "$plist"
		fi
	done
}

# Set a string value in a plist, creating the leaf key when it does not exist yet.
set_plist_string() {
	local plist=$1
	local path=$2
	local value=$3

	if /usr/libexec/PlistBuddy -c "Print ${path}" "$plist" >/dev/null 2>&1; then
		/usr/libexec/PlistBuddy -c "Set ${path} ${value}" "$plist"
	else
		/usr/libexec/PlistBuddy -c "Add ${path} string ${value}" "$plist"
	fi
}

# Restart a GUI process only when it is already running, so reruns do not fail on killall.
restart_process_if_running() {
	local process_name=$1

	if pgrep -x "$process_name" >/dev/null 2>&1; then
		killall "$process_name"
	fi
}

# From: https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# Close any open System Settings panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Settings" to quit'
# }

# System {

# Allow a sudo session to last a bit longer, across terminals.
sudoers_target=/etc/sudoers.d/99_my_settings
sudoers_has_config_marker=false
if [ -r "$sudoers_target" ] && grep -Fq "$config_marker" "$sudoers_target"; then
	sudoers_has_config_marker=true
elif [ -e "$sudoers_target" ] && run_with_sudo grep -Fq "$config_marker" "$sudoers_target"; then
	sudoers_has_config_marker=true
fi
if ! $sudoers_has_config_marker; then
	sudoers_tmp="${tmp_dir}/99_my_settings"
	cat >"$sudoers_tmp" <<EOF
${config_marker}
# Set cached password timeout in minutes.
Defaults:${USER} timestamp_timeout=16
# Single password cache for user.
Defaults !tty_tickets

# Command groups.
Cmnd_Alias CMDS_POWER = /sbin/halt, /sbin/shutdown, /sbin/reboot

# Let power users issue power commands.
%power ALL = NOPASSWD: CMDS_POWER
EOF
	visudo -cf "$sudoers_tmp"
	run_with_sudo mkdir -p /etc/sudoers.d
	run_with_sudo install -m 0440 "$sudoers_tmp" "$sudoers_target"
fi

# Create power group and add user for sudo rule above.
if ! dscacheutil -q group | grep -q "name: power"; then
	run_with_sudo dseditgroup -o create power
fi
if ! id -nG "$USER" | grep -qw power; then
	run_with_sudo dseditgroup -o edit -u "$USER" -p -a "$USER" -t user power
fi

# Sudo with Touch ID. Ref: https://news.ycombinator.com/item?id=26303170
# To work within tmux, need to use pam_reattach. Ref: https://github.com/fabianishere/pam_reattach
# Try detect if TouchID exist. Ref: https://apple.stackexchange.com/a/450646
touch_id_supported=false
if command -v bioutil >/dev/null 2>&1 && bioutil -r 2>/dev/null | grep -q "Biometrics for unlock"; then
	touch_id_supported=true
fi
pam_reattach_path=
for candidate in /opt/homebrew/lib/pam/pam_reattach.so /usr/local/lib/pam/pam_reattach.so; do
	if [ -e "$candidate" ]; then
		pam_reattach_path=$candidate
		break
	fi
done
if $touch_id_supported && { grep -Fq "$config_marker" /etc/pam.d/sudo || ! grep -q 'pam_tid\.so' /etc/pam.d/sudo; }; then
	pam_sudo_base="${tmp_dir}/pam_sudo.base"
	pam_sudo_new="${tmp_dir}/pam_sudo.new"
	grep -Fv "$config_marker" /etc/pam.d/sudo >"$pam_sudo_base"
	{
		if [ -n "$pam_reattach_path" ]; then
			printf '%s\n' "auth       optional        ${pam_reattach_path} ${config_marker}"
		fi
		if ! grep -q 'pam_tid\.so' "$pam_sudo_base"; then
			printf '%s\n' "auth       sufficient     pam_tid.so ${config_marker}"
		fi
		cat "$pam_sudo_base"
	} >"$pam_sudo_new"
	if ! cmp -s "$pam_sudo_new" /etc/pam.d/sudo; then
		run_with_sudo install -m 0444 "$pam_sudo_new" /etc/pam.d/sudo
	fi
fi
# }

# System Settings {
# Apple ID {
## iCloud
### iCloud Drive
# * Uncheck "Optimize Mac Storage", so that Time Machine can back up all data.
# }

# Network {
## Firewall
# * Turn on Firewall
## CloudflareDNS
# * Ref: https://developers.cloudflare.com/1.1.1.1/setup/macos/
# * For each network connection, manually add DNS servers: 1.1.1.1 & 1.0.0.1
# * Could do this kind of, but don't know name of all adapters and dont' want to set for all
#	$ sudo networksetup -listallnetworkservices
#	$ sudo networksetup -setdnsservers Wi-Fi 1.1.1.1 1.0.0.1
# }

# Battery {
## Options
# * Check "Prevent your mac from automatically sleeping when the display is off"
# }

# General {
# Language & Region {
# * Add English (US), Swedish, German
# defaults write NSGlobalDomain AppleLanguages -array en-us sv-se de-de
# * Region: Germany
# defaults write NSGlobalDomain AppleLocale en_DE
# Date format: yyyy-mm-dd
# }

# Sharing {
# * Set "Computer Name". Unfortunately different from system hostname (below).
# * Set computers hostname.
# Semi-idempotent; assume setting hostname is only desired to do 1 time, and that a default hostname is *.local something.
if hostname | grep -q .local; then
	new_hostname=
	while [ -z "$new_hostname" ]; do
		echo -n "Enter new computer hostname: "
		read -r new_hostname
	done
	current_hostname=$(scutil --get HostName 2>/dev/null || true)
	if [ "$current_hostname" != "$new_hostname" ]; then
		run_with_sudo scutil --set HostName "$new_hostname"
	fi
fi
# }

# Time Machine {
# * Partition the disk with APFS (Case-sensitive, Encrypted) and with GUID partition map.
# * Exclude the following paths
#	* ~/.cache/
#	* ~/Library/Caches/
# }
# }

# Apearance {
# * Appearance: Auto
# defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
# }

# Apple Intelligence & Siri {
# Listen for: Sir & Hey Siri
# Keyboard shortcut: press cmd twice
## Extensions
# Use ChatGPT: check
# }

# Desktop & Dock {
# * Add ~/ (Stack, List) and ~/Downloads (Stack, Automatic) to dock.
# * For dual monitors: For all applications in dock: Right click > Option > assign to correct monitor and desktop.

# Dim hidden apps (CMD+H) in the dock.
defaults write com.apple.Dock showhidden -boolean yes

# Add two space separators in dock, to organize icons to correspond to which monitor I want them to be open on. Let them be order by the Spaces order too.
dock_spacer_count=$(defaults read com.apple.dock persistent-apps 2>/dev/null | grep -c spacer-tile || true)
while [ "$dock_spacer_count" -lt 2 ]; do
	defaults write com.apple.dock persistent-apps -array-add '{tile-type="small-spacer-tile";}'
	killall Dock
	dock_spacer_count=$((dock_spacer_count + 1))
done

# Mission Control {
# * Unckeck "Automatically rearrange Spaces based on most recent use":
defaults write com.apple.dock mru-spaces -bool false
# }
# }

# Display {
# * Move the white menu bar to the main monitor, so notifications etc. comes on it.
# * Check "Show mirroring options in the menu bar when available".
## Night Shift
# * Schedule: Sunset to Sunrise
# }

# Menu Bar {
## Menu bar controlls (add to Control Center)
# - Sounds: Recognize music (Shazam)
# - Notes: Quick Note
# - Budget Flow: Add new expense
## Menu bar items to show (not mentioned = disabled)
# - Wi-Fi: check
# - Battery: check
# - Focus: when active
# - Screen Mirroring: when active
# - Display: when active
# - Sound: always
# - Text Input: check
# - Time Machine: check
# - Timer: when active
# }

# Spotlight {
# Help Apple Improve Search: uncheck
# Clipboard history is available in Spotlight: 7 days
# }

# Wallpaper {
# * Add all folders in ~/media/images/wallpapers/dynamic_mac/.
#   * See https://www.dynamicwallpaper.club/docs on how to use custom dynamic images.
#   * See https://apple.stackexchange.com/questions/71070/how-to-change-desktop-wallpaper-for-all-virtual-desktops/415790#415790 on how to set wallpaper for all desktops.

###  Hot Corners:
# Top right: Mission Controll
# Bottom Left: Desktop
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
# defaults write com.apple.dock wvous-tl-corner -int 0
# defaults write com.apple.dock wvous-tl-modifier -int 0
# * Top Right corner: Mission Control
# defaults write com.apple.dock wvous-tr-corner -int 2
# defaults write com.apple.dock wvous-tr-modifier -int 0
# * Bottom Left corner: Desktop
# defaults write com.apple.dock wvous-bl-corner -int 4
# defaults write com.apple.dock wvous-bl-modifier -int 0
# * Bottom Right corner: NOP
# defaults write com.apple.dock wvous-br-corner -int 0
# defaults write com.apple.dock wvous-br-modifier -int 0
# }

# Notifications {
## Notifications & Live Activities
# * Allow notifications from iPhone: check
# }

# Sound {
# * Play sound on startup: uncheck
# }

# Lock Screen {
# * Turn display off on battery when inactive: 2 minutes
# * Turn display off on power adapter when inactive: 10 minutes
# * Require password after screen saver...: Immediately
# }

# Privacy & Security {
## Security
# * Allow applications from: App Store & Known Developers
if ! spctl --status 2>/dev/null | grep -q 'assessments disabled'; then
	run_with_sudo spctl --master-disable
fi
# }

# Touch ID & Passwords {
# * Add a few fingers
# }

# Internet Accounts {
# }

# Keyboard {
# * Key repeat rate: fastest
# * Delay until repeat: 2nd most right value
# * Turn off backlit after: 30 seconds.
## Text Replacements
# * Set word expansions based on ~/doc/tech/word_expansions.txt
## Keyboard Shortcuts
### Modifier Keys
# ** NOTE if need to swap fn and ctrl on internal keyboard, use karabiner-elements.
# * For internal keyboard:
#    - Set Caps Lock -> Escape
# * For external keyboard:
#    - Set Caps Lock -> Escape
#    (unless the keyboard is an Apple keyboard or has a "mac-switch" toggle):
#    - Set Option -> Command
#    - Set Command -> Option
### Mission Control:
# * Show Notification Center: Cmd+F11
# * Enable shortcuts Ctrl+[1-5] for switching to Desktops. (Need to open 5 spaces for this to show up + restart System Settings)
## Dictation
# * Enable
# }

# Mouse {
# For setting a new speed, easiest is to set the value in System Settings, then read desired value $(defaults read -g com.apple.mouse...)
# * Tracking Speed:
#defaults write -g com.apple.mouse.scaling 0.875  # 1st vertical mouse, 1/2
defaults write -g com.apple.mouse.scaling 0.6875 # 2nd vertical mouse, 1/2 -1 notch
# * Scrolling speed: 3/4
defaults write -g com.apple.scrollwheel.scaling 0.75
# * Double-click speed: 3/4
defaults write -g com.apple.mouse.doubleClickThreshold 0.8

# }

# Trackpad {
## Point & Click
# * Check "Tap to click"
## More Gestures
# * App Expose: Swipe down with three fingers
# }

# Printers & Scanners {
# Automatically quit printer app once the print jobs complete.
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# }
# }

# Spotlight {
## Actions shortcuts
# * New Reminder: nr
# }

# Archive Util.app {
# * Uncheck "Reveal expanded items in Finder"
# }

# App Store {
# * Uncheck "Video Autoplay"
# * Uncheck "In-App Ratings & Reviews"
# }

# Calendar.app {
## Advanced
# * Check "Turn on time zone support"
# * Check "Show events in year view"
# * Check "Show week numbers"
# }

# Finder.app {
## View
# * Show Path Bar
# * Show Status Bar
### Show View Options
# * First make sure to be in ~/ & in Column view before entering this menu
# * Check "Always open in Column view" > Use as default
# * Also open this dialog while being in ~/, then check "Show Library Folder". Reference: https://appletoolbox.com/unhide-access-mac-library-folder/:
# * Show Library Folder: check
## Preferences
### General
# *** Show on desktop: External disks, CD/DVD/iPOD, Connected servers
# *** New Finder window shows: ~/
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"
### Sidebar
* Hide: Shared
### Advanced
# * Show all file extensions: check
# * Show warning before changing an extension: uncheck
# * Show warning before remvoing from iCloud Drive: uncheck
# * Keep folders on top: In windows when sorting by name

## Sidebar Strucutre
### Favorites
# - ~/
# - ~/Downloads
# - ~/media/images/screenshots/
# - ~/src/github.com/
# - ~/media/
# - ~/tmp/
# - ~/media/music/🎙️ BTB Podcast/
# - ~/media/music/daw/ableton/
# - /Applications
# - ~/.config/finder/---------/

## Desktop
# Right click > Sort by > Snap to grid
# }

# Notification Center Widgets {
# * On the notification/widget dropdown (click on clock), keep the following widgets
# - Batteries: Status (S)
# - Calendar: Month (S)
# - Calendar: Up next (S)
# - Forest (iPhone): Today's forest(S)
# - Weather: Forecast (L)
# - Screen Time: Daily widget (L)
# }

# Mail.app {
# * Toolbar, arrange to: <archive|trash|spam> <space> <Get New><New mail> <space> <reply|reply-all|forward> <space> <search>
# * In the New Mail window toolbar, click Aa to activate formatting options.
## Settings
### General
# * Uncheck "Follow Up Suggestions"
# Junk Mail
# * Check "Enable Junk mail filtering"
# * When junk mail arrives: Move it to the Junk mailbox
### Viewing
# * Check "Automatically view next message after discarding or archiving a message"
### Signatures
# * Add new signature "Standard".
# }

# Music.app {
## Playback
# * Uncheck "Song Transitions"
# * Check "Sound Enhancer"
## Files
# * Check "Keep music Media folder organized"
# * Uncheck "Copy files to Music Media folder when adding to library"
## Advanced
# * Check "Automatically update artwork"
#
#
## Import process:
# * Keep originals in ~/media/music (so that they are safe in iCloud Drive) and don't let Music.app oganize the folder or import them to ~/Music/.
# * On new system.
#    * Music.app > File > Add to Library > "artists" folder
#    * Drag and drop each subdir of "collections" one-by-one (multi drop creates just one big playlist) as a new playlist. Put playlists in a folder "Local Files" to distinguish these playlsits from iPhone made playlists with purchased iTunes music.
# * Adding more files: first add to ~/media/music then
# * From "artists"; drag-and-drop to Library
# * From "collections"; drag-and-drop to corresponding playlist in the sidebar.
# }

# Photos.app {
## General
# * Check "Show holiday events"
# * Check Sharing: "Include location information"
## iCloud
# * Select "Download Originals to this Mac"
# }

# Terminal.app {
#Profiles
## Shell
# * When the shell exists: close if the shell exited cleanly
defaults write com.apple.Terminal ShellExitAction -int 1
# }

# Safari.app {
# View
# * Click "Show favorites bar"
# Customized Toolbar:
# * Add Icloud Tabs button
## Preferences
### General
# * Safari opens with: All windows from last session
# * Homepage: favorites://
# * Remove history items: manually
# * Uncheck "Open safe files after downloading"
### Advanced
# * Check "Show features for web developers"
# }

# Misc {
# Change screenshot destination from Desktop to something sane.
mkdir -p "$HOME/media/images/screenshots"
defaults write com.apple.screencapture location "$HOME/media/images/screenshots"
# }

restart_process_if_running Dock
restart_process_if_running Finder
echo "Please logout or restart for all settings to take effect."

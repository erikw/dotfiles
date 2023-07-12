#!/usr/bin/env bash
# NOTE make sure this script is idempotent!
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0
# }

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# Installs: Automated {
# Add brew to PATH with eval.
brew_bin=
if [ -e /opt/homebrew/bin/brew ]; then  # Apple Silicon macs
	brew_bin=/opt/homebrew/bin/brew
elif [ -e /usr/local/bin/brew ]; then  # Intel Macs
	brew_bin=/usr/local/bin/brew
else
	echo "Could not detect Homebrew installation path" >&2
	exit 1
fi
eval "$(${brew_bin} shellenv)"


brewfile_global="${XDG_CONFIG_HOME:-$HOME/.config}/homebrew/Brewfile"
brewfile_host_specific="${brewfile_global}.$(hostname)"
if [ -e $brewfile_host_specific ]; then
	brew bundle install --file $brewfile_host_specific
fi

# Make homebrew zsh default shell. Reference: https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
cur_sh=$(dscl . -read /Users/$USER UserShell | cut -d' ' -f2)
brew_zsh=$(brew --prefix)/bin/zsh
if [ "$cur_sh" != "$brew_zsh" ]; then
	echo "Setting Homebrew zsh as the default shell."
	sudo dscl . -create /Users/$USER UserShell $(brew --prefix)/bin/zsh
fi

# Automatic upgrades. Reference: https://github.com/Homebrew/homebrew-autoupdate
# There's no nice way to set this up with brew-bundler. Only the tap can be put there, but not of the configuration, so might as well keep it all here until then.
if ! [ -e "$HOME/Library/LaunchAgents/com.github.domt4.homebrew-autoupdate.plist" ]; then
	mkdir -p $HOME/Library/LaunchAgents # Might not exist.
	brew tap homebrew/autoupdate
	# Start upgrade (including casks) every 12 hours.
	brew autoupdate start 43200 --upgrade --cleanup
	brew autoupdate status
fi

# Notification queue service
#mkdir -p $HOME/Library/LaunchAgents
#ln -s $HOME/.config/LaunchAgents/com.user.notificationqueue.plist $HOME/Library/LaunchAgents/
#launchctl bootstrap gui/$UID $HOME/Library/LaunchAgents/com.user.notificationqueue.plist
#launchctl enable gui/$UID/com.user.notificationqueue


# fzf fuzzy finder. Installed via brew. Specify all options on cli for a non-interative setup.
if ! [ -e $HOME/.config/fzf/fzf.zsh ]; then
	$(brew --prefix)/opt/fzf/install --xdg  --key-bindings --no-update-rc --no-completion
fi

## Crontab {
# NOTE migrated to dotbot plugin
# Install ~/bin/dotfiles_backup_local.sh cron entry.
#tab_entry="0 13 * * *			if_fail_do_notification dotfiles_backup_local.sh"
#tab_old=$(crontab -l)
#if ! echo "$tab_old" | grep -qF "$tab_entry"; then
#    tab_new=$(printf "%s\n%s\n" "$tab_old" "$tab_entry")
#    echo "$tab_new" | crontab -
#fi


# Crontab backup automation
#tab_entry="@monthly			if_fail_do_notification crontab_backup.sh"
#tab_old=$(crontab -l)
#if ! echo "$tab_old" | grep -qF "$tab_entry"; then
#    tab_new=$(printf "%s\n%s\n" "$tab_old" "$tab_entry")
#    echo "$tab_new" | crontab -
#fi

## }
# }

# Installs: Manual {
# General System {

# EurKey
# Enable the keymap from System Preferences > Keyboard > Input Sources. Replace US with EurKey.


# Brother DCP-7070dw
# * Printer
#   * Install driver from https://support.brother.com/g/b/downloadtop.aspx?c=eu_ot&lang=en&prod=dcp7070dw_eu
#   * System Preferences > Printers & Scanners > + > Add by Bonjour discovery on network
# * Scanner: user the "Brother iPrint&Scan" app from App Store, as the ICA driver (Image Capture.app) is not working.
# * If not already the case, make sure lpr uses the default printer:
#lpstat -p -d
#lpoptions -d Brother_DCP_7070DW
#lpoptions -p Brother_DCP_7070DW  -o PageSize=A4 -o Printing=DuplexNoTumble -o Duplex/Two-Sided=true
#
# Then set default options used for gui printing diaglog.
# Ref: https://support.pirateship.com/en/articles/2799085-mac-how-to-change-default-printer-settings
# * $ cupsctl WebInterface=yes
# * Go to http://localhost:631/printers/ log in with system user and password
# * Select my printer > Dropdown: Set Default Options
#   - Media Size: A4
#   - Two-Sided Printing: Long-Edge Binding


# Anti malware: Avira: https://www.avira.com/en/free-antivirus-mac
# the cask brew does not work with system extension
#brew install avira-antivirus


# Amethyst
## General
# * Uncheck "Display layout when changing spaces".
## Layouts
# * Set the following layouts to be used: tall, fullscreen, floating.
## Shortcuts
# Disable shortcuts as they conflict with EurKey input (like capital ÄÅ)
# * Focus screen 1 (opt+shift+w), as opt+w produces Ä.
# * Select Tall layout (opt+shift+a), as opt+shift+a produces Å.
## Floating
# * Add Pixelmator Pro, as the mouse hover tooltips are treated as own windows.

# Clipy
## General
# * Max clipboard history size: 100
## Menu
# * Number of items to place inline: 25
# * Number of items to place inside a folder: 75
# * Number of characters in the menu: 50
## Shortcuts
# * Menu>Main: NOP
# * Menu>History: Cmd+Shift+v.
# * Menu>Snipets: Cmd+Shift+b.
# * History>Clear history: Shift+ctrl+opt+cmd+c
## Snippets
# Create snipets for some common items in ~/doc/tech/word_expansions.txt


# Dictionary.app
# * Install the SWE-EN dictionary from https://github.com/hashier/MacFolket

# Scroll Reverser
## Scrolling
# * Check: Enable Scroll Reverser
# * Scrolling devices:
#  - Uncheck: Reverse Trackpad
#  - Check: Reverse Mouse
## App
# * Check: Start at login
# * Uncheck: Show in menu bar

# Sensiblesidebuttons || Sanesidebuttons.
# * Launch it one time to set right permissions needed.
# * From menu bar icon: hide icon
# * System Settings > General > Login items > add it manually


# Mail.app
## GMailinator plug-in. The most maintained fork is https://github.com/wwwjfy/GMailinator, but using another fork's install.sh makes it easier: https://github.com/jasoncodes/GMailinator/blob/master/install.sh
# Req: full XCode.app installed from app store.
# ghq-get git@github.com:jasoncodes/GMailinator.git
# ./install.sh
# Then go to Mail.app > Preferences > General > Manage Plug-ins... > enable GMailinator

# iTerm2
# * Load settings from Preferencs > General > Preferences tab > Load from custom folder or URL. Reference: https://stackoverflow.com/a/23356086/265508
# * Give iterm full disk access, to avoid may different permission request popups later
#    * System Preferences > Security & Privacy > Privacy > Full Disk Access > Add Iterm.app
## General
### Closing
# * Make it easier to restart/poweroff by not confirming closing multiple windows - I always use tmux so it's not a problem.
#   - Uncheck: Confirm closing multiple sessions.
#   - Uncheck: Confirm "iTerm2 (#Q)""
### Selection
# * Check "Applications in terminal may access clipboard" so that I can e.g. copy from vim buffer to GUI clipboard.
### Colors
# * Check "use different colors for light and dark mode"
#   * For Light Mode and Dark Mode, select Color Preset.. with Solarized Light/Dark respectively.
### Text
# * Set font to either
# ** DM Mono, Regular, 14pt
# ** Source Code Pro, Regular, 14pt
# ** Terminus, Medium, 16pt
# ** Any NerdFont when using lsd(1) e.g.: Hack Nerd Font, Regular, 14pt
### Terminal
# * Notifications > Check "Silence Bell"
# * Check "Unlimited Scrollback"
### Keys
#### General
# * Make Option key an Meta key, so e.g. tmux binding works on MBP internal keyboard.
#   - set "Left option key acts as" "Esc+". NOTE need karabiner-elements to get left alt to work on external PC keyboard.
#### Key Mappings
# * Create shortcuts to toggle between solarized dark & light:
#	- Press the '+' button:
#		- Shortcut: Opt + Cmd + s
#		- Action: "Load Color Preset" > "Solarized Light"
#	- Press the '+' button:
#		- Shortcut: Opt + Cmd + shift + s
#		- Action: "Load Color Preset" > "Solarized Dark"



# Jettison
## Options
# * Check Launch at start
### Hotkeys
# * Eject external disks: ctrl + opt + cmd + e
# * Eject disks and sleep: ctrl + opt + cmd + s

# The Unarchiver
## Archive formats
# Enable for most archives. Might have to change in Finder for it to be the default program for some files.
## Extraction
# * Uncheck "Reveal expanded items in Finder".

# Dropbox
# * Remove ~/Dropbox symlink and create: $ ln -s /Users/erikw/Library/CloudStorage/Dropbox ~/dropbox
# * Create symlinks from ~/Library/CloudStorage/Dropbox/* to ~/. Don't create from ~/dropbox because when there's >1 level of indirection, the macOS doc won't follow the symlinks in the Stacks (list) folder feature.
## General
# * Dropbox badge: Never show (integrates in to MS Office for example)



# Custom fonts
# * Open Font Book.app > File > Add Fonts > ~/media/fonts/
#   * Skip all fonts with warnings/errors on

# Pixelmator Pro
## General
# * Appearance: Auto
# * New Image contents: transparent
## Extension
# Select "Save to Pictures" instead of iCloud

# Todoist
# * Disable macOS spelling correction in search bar by right clicking in search bar > Spelling and Grammar > uncheck "Correct Spelling Automatically". Reference: https://osxdaily.com/2011/08/18/disable-spelling-auto-correct-safari-mac-os-x/
# * Disable badge count on Dock icon: System Preferences > Notifications > Todoist > uncheck "Badge app icon"


# dictcc-en-de-dictionary-plugin
# From https://www.dict.cc/?s=about%3Awordlist&l=e
# To use it;
# - open Dictionary.app > Preferences > enable and up the pref order of the "Deutsch-Englisch" dictionary.

# Crontabs
# If using Spotify, add an entry to local user's crontab:
# @monthly			if_fail_do_notification spotify-backup.sh

# }

# Automator Actions {
# Automator command for starting screen saver.
# 1. Open automator
# 2. Create a new service (now named Quick Action)
# 3. Choose "Run AppleScript"
# 4. In the top of the window, select for "Service receives selected" to "no input" and "in any application".
# 5. Paste contents of ~/bin/automator/start_screensaver.command so it basically becomes:
#on run {input, parameters}
	#do shell script "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"
	#return input
#end run
# 5. Save with the name "start_screensaver.
# 6. Open System Peferences>Keyboard>Shortcuts>Services>General and assign this quick action the shortcutl CTRL+CMD+L.
# If start_screensaver save did not show up, try logging in and out or restarting the computer.


# Automate command: toggling system light/dark mode.
# * Create an Automator.app Quick Action named "appearance_toggle".
# * Use the build-in action "Change System Appearace" by dragging it in to the right, and set "Change Appearance" to "Toggle Light/Dark". This seems to go faster when toggling than the custom script ~/bin/automator/appearance_toggle.command
# * Bind to Service shortcut CTRL+OPT+CMD+t (shortcut used when feature was first introduced in the OS).


# Automator command: start Microsoft To Do
# * Create an automator Quick Action named "ms_todo_start" with AppleScript with action "Launch Application"
# * Bind to shortcut ctrl+cmd+y


# Automator command: cycle output devices. Do this for all ~/bin/automator/SwitchAudioSource*.command
# * Create an automator Quick Action named "SwitchAudioSource_cycle" with AppleScript for the contents in ~/bin/automator/SwitchAudioSource_cycle.command
# * Bind to shortcuts like:
#  - Built-in: CMD+OPT+F11.
#  - USB Soundcard/headset: CMD+OPT+F12
#  - Cycle: CMD+OPT+F13.


# Automator command: showing Control Center.
# TODO replace this with native System Preferences shortcut when supported.
# * Create an automator Quick Action named "open_controlcenter" with AppleScript for the contents in ~/bin/automator/open_controlcenter.command
# * Bind to shortcut CMD+F10
# * For this to work, System Preferences > Security & Privacy > Privacy > Accessibillity > allow System Preferences.app.


# Automator command: showing Now Playing
# TODO replace this with native System Preferences shortcut when supported.
# * Create an automator Quick Action named "open_nowplaying" with AppleScript for the contents in ~/bin/automator/open_nowplaying.command
# * Bind to shortcut CMD+F9
# * For this to work, System Preferences > Security & Privacy > Privacy > Accessibillity > allow System Preferences.app.
# }

# Development {
# General {
# Dash.app
## General
# * Show Dash and focus on search field: cmd+shift+d
# * Uncheck "Show dock icon"
# * Check "Show menu bar icon"
# * Sync: set folder ~/dropbox/data/dash/    # own subdir so this dir can be shared with work Dropbox account.
# }

# C/C++ {
# LSP server
# brew install ccls
# }

# Go {
# asdf version manager - golang
#asdf plugin-add golang
#asdf install golang latest
#asdf global golang latest
# }

# Java {
# asdf version manager - java
#asdf plugin-add java
# Build requirements from https://github.com/halcyon/asdf-java
#brew install bash curl unzip jq

# LSP server
# No good one exist that are easily installable. https://microsoft.github.io/language-server-protocol/implementors/servers/
# https://github.com/eclipse/eclipse.jdt.ls is clumsy. No brew. Only hack that is not working: https://github.com/edganiukov/homebrew
# }

# Ruby {
# asdf version manager - ruby
#asdf plugin-add ruby
# Build requirements for building all ruby versions from https://github.com/asdf-vm/asdf-ruby
#brew install openssl@1.1 openssl@3 readline libyaml gmp rust
#export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"  # Also set in shell commons for future builds
# NOTE might have to unset $GEM_HOME before installing with rbenv: https://github.com/asdf-vm/asdf-ruby/issues/206#issuecomment-860106503

# Install latest ruby
#asdf install ruby latest
#asdf global ruby latest


# Rails
# Reference: https://sergio-ildefonso.medium.com/install-ruby-and-rails-on-a-mac-7b8a1ccb5f4
# Reference: https://gorails.com/setup/osx/10.13-high-sierra
#gem install rails
## Dependencies
# sqlite - macOS version is old
#brew install sqlite3
# npm - get a node manager to manage versions. NVM is slow and cumbersome => n. NOPE is the way to goASDF! See node section
# yarn - better than npm
#npm install -g yarn
# NOTE unset CC=clang if creating a new rails app, as dependency byebug fails with clang.
# }

# Python {
# State of the art:
# * Python version - pyenv, or better with asdf
# * Project dependences - poetry
# * Global python tools - pipx

# asdf version manager - python
#asdf plugin-add python
# Build requirements from https://github.com/danhper/asdf-python
#brew install openssl readline sqlite3 xz zlib
#asdf install python latest
#asdf global python latest

#curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
#poetry completions zsh > $XDG_CONFIG_HOME/zsh/funcs/_poetry
# and reload compinit

# }

# JavaScript {
# asdf version manager - nodejs
#asdf plugin add nodejs
# Build requirements from https://github.com/asdf-vm/asdf-nodejs/
#brew install gpg gawk
#asdf install nodejs latest
#asdf global nodejs latest
# }
# }

# DJing {
# Djay Pro AI
## General
# * Slide Range +-: 8% # Compromise of 6% or 10%. https://www.reddit.com/r/Beatmatch/comments/c9012w/pitch_control_6_or_10_my_thoughts_and_asking_for/
#   * Do +6% for learning, the fader is so small
# * Uncheck: Reset (EQ, effect, controls)
# * Stop time: 0,0 seconds
## Devices:
# * See ~/doc/music/device_setups.xlsx Dj tap
## Library:
# * Check: Hide unavailalbe tracks
## Appearance:
# * Fontisze: 3/4
# * Check: Show bar numbers
# * Check: Show minute markers
# * Check: Dim inactive deck

# }

# Music Production {
# Ableton Live
# * Download from https://www.ableton.com/en/account/
# root=/Volumes/ext0/daw/
## Look and Feel
# * Theme: Dark
## Audio
# Use CoreAudio driver and Scarlette 2i2 for input/output, according to ~/doc/man/music/focusrite_scarlett-2i2-3rd_genuser-guide.pdf page 10, or   https://getstarted.focusrite.com/en/scarlett/set-your-input-and-output-device
# * Driver Type: Core Audio
# * Audio Input Device: Scarlette 2i2 USB
# * Audio Output Device: Scarlette 2i2 USB
# * IO Sample rate: 44100
# * Default SR Conversion: High Quality
# * Buffer size: 512 samples
# * Driver Error Compensation: 0.0
## Link MIDI
# * Set up Ableton MIDI input/output according to ~/doc/man/music/novation_launchkey_mk3_manual_v1.03.pdf page 12.
# * Control Surfaces, the 2 first rows should be
#   - Control Surface: Launchkey MK3
#   - Input: Launchkey MK3 37 (LKM3 DAW Output)
#   - Output: Launchkey MK3 37 (LKM3 DAW Input)
# * Takeover mode: pickup
# * Control Surfaces:
# - Input Launchkey MK3 37 (LKM3 MIDI Output):	Tack=On, Sync=Off, Remote=On
# - Input Launchkey_MK3 Input (Lanuchkey):	Tack=On, Sync=Off, Remote=On
# - Output Launchkey MK3 37 (LKM3 MIDI Input):	Tack=On, Sync=On, Remote=On
# - Output Launchkey_MK3 Output (Launchkey):	Tack=On, Sync=Off, Remote=On
## Files and Folders
# * Adjust the default empty project "Save current Set as Default" with a new project:
#  - Keep 1 MIDI track only with brown color (drums).
#  - Set preview volume on master channels' mixer to -8dB as my headphones are very loud by default.
## Library
# * Location of User Library: $root/ableton/includes/user_library/
# * Installation Folder for Packs: $root/ableton/includes/factory_packs/
## Plug-Ins:
# * Note, use the Custom Paths as my own install paths, while keeping manuals etc in $root/plugins/installers/. See https://help.ableton.com/hc/en-us/articles/209068929-Using-AU-and-VST-plug-ins-on-Mac
# * Use VST2 Plug-In System Folder: true
# * Use VST2 Plug-In Custom Folder: true
# * VST2 Plug-In Custom Folder: $root/plugins/VST/
# * Use VST3 Plug-In System Folder: true
# * Use VST3 Plug-In Custom Folder: true
# * VST3 Plug-In Custom Folder: $root/plugins/VST3/
## Other
# * Add these directories to the Ableton browser:
# $root/../music/samples/
# $root/ableton/packs/
# $root/ableton/templates/
# $root/ableton/ableton_template_sets/
# $root/ableton/max/
# }
# }

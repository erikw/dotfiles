#!/usr/bin/env bash
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=4:
# }

set -ex

# Installs: Automated {
# Install homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Using Brewfile at $HOMEBREW_BUNDLE_FILE
brew bundle install

brewfile_host_specific=$HOMEBREW_BUNDLE_FILE.$(hostname)
if [ -e $brewfile_host_specific ]; then
	brew bundle install --file $brewfile_host_specific
fi

# Make homebrew zsh default shell. Reference: https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh


# Automatic upgrades. Reference: https://github.com/Homebrew/homebrew-autoupdate
# There's no nice way to set this up with brew-bundler. Only the tap can be put there, but not of the configuration, so might as well keep it all here until then.
brew tap homebrew/autoupdate
brew install terminal-notifier
# Start upgrade (including casks) every 12 hours.
brew autoupdate --start 43200 --upgrade --cleanup --enable-notification
brew autoupdate --status

# Python setup {
# Python lists {
set +e # Can't have -e while making these vars
make_1line() {
	echo "$1" | tr '\n' ' '
}
read -r -d '' pip3_pkgs <<-'EOAPPS'
	ipython
	pip-autoremove
EOAPPS
pip3_pkgs=$(make_1line "$pip3_pkgs")

read -r -d '' pip3_pkgs_additional <<-'EOAPPS'
	goobook
	ipdb
	iterm2
	pipenv
	powerline-status
	pudb
	pyenv
	ropevim
	virtualenvwrapper
EOAPPS
pip3_pkgs_additional=$(make_1line "$pip3_pkgs_additional")
set -e
# }
pip3 install --user $pip3_pkgs
#pip3 install --user $pip3_pkgs_additional

# * If wanting different python version than given by brew, use pyenv(1).
# * To manage project package dependences, use pipenv with Pipfile and virtualenvs
# See https://towardsdatascience.com/python-environment-101-1d68bda3094d#39b6
## Alternatives for global packages install
# * pipenv with a Pipfile:
#   - https://packaging.python.org/tutorials/managing-dependencies/
#   - However this is more for project package dependencies. Global install is not working (from https://stackoverflow.com/a/54342856)
# * Pipex: https://github.com/pipxproject/pipx
#  - However not offering any real benefits for my setup, there's not Pipefile or such to specify packages or versions needed.
# * https://miro.medium.com/max/577/1*w-gYboE96IYdDBUDR7QokQ.png
# }

# Install tmux session on login.
# Reference: http://www.launchd.info/
# NOPE starting tmux with launchctl makes it run with less access e.g. doing $(ls /volumes/somevolume) gives "Operation not permitted".
# thus, instead go for a simpler solution: Autostart;
# 1. Set Iterm.app to auto-start
# 2. Set iterm2 default profile to start irctor, and then have an additional profile that just runs zsh. see #irctorautostart below in the iterm section.
# old below:
#mkdir -p $HOME/Library/LaunchAgents
#cp $HOME/bin/com.user.irctor.plist $HOME/Library/LaunchAgents/
#launchctl load -w $HOME/Library/LaunchAgents/com.user.irctor.plist
#launchctl start com.user.irctor
#launchctl list | grep com.user.irctor
#launchctl unload -w $HOME/Library/LaunchAgents/com.user.irctor.plist
# Start iterm2.app with tmux session loaded on login.
#cp $HOME/bin/com.user.iterm.plist $HOME/Library/LaunchAgents/
#launchctl load -w $HOME/Library/LaunchAgents/com.user.iterm.plist
#launchctl start com.user.iterm


# solarized_toggle.sh
## solarized_toggle.sh require
# - pip3 package iterm2 mus be installed (in python setup above)
# - iterm2 preference enable Python API: General > Magic tab > Enable Python API: Require "automation" permission.
#	(if this is not enough Iterm2 > Scripts (menu) > Manager > Install runtime)
## Start macos_appearance_monitor.sh on login.
cp $HOME/bin/com.user.appearancemon.plist $HOME/Library/LaunchAgents/
launchctl load -w $HOME/Library/LaunchAgents/com.user.appearancemon.plist
launchctl start com.user.appearancemon
# Create symlink so that ~/bin/solarized_iterm2_set.py works.
ln -s $HOME/Library/Application\ Support Library/ApplicationSupport
## Automate command for toggling system appearance mode
# * Create an automator Quick Action named "appearance_toggle" with AppleScript for the contents in ~/bin/macos_appearance_toggle.command
#	* NOPE use the build-in action "Change System Appearace" by dragging it in to the right, and set "Change Appearance" to "Toggle Light/Dark". This seems to go faster when toggling than the custom script.
# * Bind to shortcut CTRL+OPT+CMD+t (shortcut used when feature was first introduced in the OS).


# wego from brew is not recognizing forecast.io backend.
#go get -u github.com/schachmat/wego


# Update gnu locate database on schedule by appending crontab.
#newtab="* */2 * * * /usr/local/Cellar/findutils/4.6.0/bin/updatedb --prunepaths='/tmp' >/dev/null 2>&1"
# NOTE disabled as updatedb takes too much CPU on macOS, making other work hard.
#newtab="* */2 * * * /usr/local/Cellar/findutils/4.6.0/bin/updatedb --localpaths='/etc $HOME' >/dev/null 2>&1"
#oldtab=$(sudo crontab -l)
#if [ -n "$oldtab" ]; then
	#newtab=$(printf "%s\n%s\n" "$oldtab" "$newtab")
#fi
#sudo sh -c "echo \"$newtab\" | crontab -"

# Git
email=
while [ -z "$email" ]; do
	echo -n "Enter email address for ~/.gitconfig.local: "
	read email
done;
cat << EOF >>  ~/.gitconfig.local
[user]
	email = $email
EOF

# NPM global packages. npm is installed by Brewfile
~/bin/npm-install-global.sh

# Make tig use $XDG_DATA_HOME. Reference: https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
mkdir -p ${XDG_DATA_HOME:-$HOME/.local/share}/tig

# Vim {
# Install Vundle plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c PlugInstall

#  Instant Markdown Preview
# https://github.com/instant-markdown/vim-instant-markdown
#npm -g install instant-markdown-d

# command-t
#cd $HOME/.vim/bundle/command-t/ruby/command-t/ext/command-t
#ruby extconf.rb
#make
#cd -
# }

# Neovim {
# Install vim-plug: https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c PlugInstall


# }


# fzf fuzzy finder. Installed via brew
$(brew --prefix)/opt/fzf/install --xdg

# }

# Installs: Manual {
# General System {
# General manual install list
# * easytag
# * Xcode XVim: https://github.com/XVimProject/XVim, https://github.com/XVimProject/XVim/blob/master/INSTALL_Xcode8.md


# Brother DCP-7070dw
# * Printer
#   * Install driver from https://support.brother.com/g/b/downloadtop.aspx?c=eu_ot&lang=en&prod=dcp7070dw_eu
#   * System Preferences > Printers & Scanners > + > Add by Bonjour discovery on network
# * Scanner: user the "Brother iPrint&Scan" app from App Store, as the ICA driver (Image Capture.app) is not working.
# * If not already the case, make sure lpr uses the default printer:
#lpstat -p -d
#lpoptions -d Brother_DCP_7070DW

# Antivirus: Avast Security for Mac
# https://www.avast.com/en-us/free-mac-security
# the cask brew does not work
#brew install avast-security
# NOPE too much pop-ups and upsells, instead
# Antivirus: Avira: https://www.avira.com/en/free-antivirus-mac
# the cask brew does not work with system extension
#brew install avira-antivirus


# BankId på fil
# Instructions: https://swedbank.se/privat/digitala-tjanster/mobilt-bankid/bankid-pa-kort-och-fil/bankid-pa-fil.html
# Install: https://install.bankid.com/, prefer cask!

# Amethyst
## General
# * Uncheck "Display layout when changing spaces".
# * Set the following layouts to be used: tall, fullscreen, floating.
## Floating
# * Add Pixelmator Pro, as the mouse hover tooltips are treated as own windows.

# Clipy
## General
# * Max clipboard history size: 85
## Menu
# * Number of items to place inline: 25
# * Number of items to place inside a folder: 60
# * Number of characters in the menu: 50
## Shortcuts
# * Menu>Main: NOP
# * Menu>History: Cmd+Shift+v.
# * Menu>Snipets: Cmd+Shift+b.
## Snippets
# Create snipets for some common items in ~/doc/tech/word_expansions.txt


# Firefox
## Firefox (menu bar) > Customize Touch Bar..
# * Replace Share with Reading mode.
# * Set up according to firefox.txt

# FreshBackMac
# NOPE replace by Irvue
# * Add to auto start in Settings > Users & Groups > Login items.
# * Set daily refresh
# * Turn off desktop notifications.

# Irvue
# Prefer this to Freshbackmac as one can get info about the selected wallpaper.
# NOTE switch to built-in dynamic wallpapers with dark/light mode.
## General
# * Folder for saved wallpaper: ~/media/images/wallpapers/usplash/
# * Uncheck Notifications
# * Check Load at startup:
## Shortcuts
# * Change wallpaper: Ctrl + Shift + Cmd + W (to be consistent with Freshbackmac)
# * Disable all other shortcuts as e.g. opt+cmd+r conflicts with Firefox reading mode, cmd+opt+s with iTerm solarized toggle.
# ** It's not enough to uncheck a shortcut, it's value has to be deleted otherwise it will be enabled again.


# Spotify Notifications
# NOPE Replaced with native Now Playing Menu Bar.
# * Set shortcut to show current playing to: Ctrl + Opt + Cmd + p

# MacVim
# * Make the app quit when the last buffer is closee: " MacVim > Preferences > After the last window closes: QuitMacVim.
# * Open text files with MacVim
#	* Find any .txt file in Finder > cmd+i on it > Open with > MacVim > Change for all

# Scroll Reverser
## Scrolling
# * Check: Enable Scroll Reverser
# * Scrolling devices:
#  - Check: Reverse Trackpad
#  - Uncheck: Reverse Mouse
## App
# * Check: Start at login
# * Uncheck: Show in menu bar

# Sensiblesidebuttons
# * Launch it one time to set right permissions needed.
# * From menu bar icon: hide icon

# iTerm2
# * Load settings from Preferencs > General > Preferences tab > Load from custom folder or URL. Reference: https://stackoverflow.com/a/23356086/265508
# * Give iterm2 full disk access: System Preferences > Security & Privacy > Privacy > Full Disk Access > add iTerm.app
## General
### Closing
# * Make it easier to restart/poweroff by not confirming closing multiple windows - I always use tmux so it's not a problem.
#   - Uncheck: Confirm closing multiple sessions.
#   - Uncheck: Confirm "iTerm2 (#Q)" if windows open"
# * iterm.sh: If iterm2.app is closed, 2 windows will be opended by this script. To prevent this:
#	- Startup > Select "Only Restore Hotkey Window" NOPE don't do this anymore as of #irctorautostart
### Selection
# * Check "Applications in terminal may access clipboard" so that I can e.g. copy from vim buffer to gui clipboard.
## Profiles
#* After configuring the default profile, clone it in to a profile called "zsh" and remove the "Send text at start" #irctorautostart
### General
# * Send text at start: "irctor"   #irctorautostart
### Colors
# * Select color preset "Solarized Ligt". With macOs appearance following the sun, it's much more likely to be day time and thus no need to switch color in irctor on start.
### Text
# * Set font to either
# ** Source Code Pro, Regular, 14pt
# ** Terminus, Medium, 16pt
### Terminal
# * Check "Silence Bells"
### Terminal
# * Check "Unlimited Scrollback"
### Keys
# * Make Option key an Meta key, so e.g. tmux binding works on MBP internal keyboard.
#   - set "Left option key acts as" "Esc+". NOTE need karabiner-elements to get left alt to work on external PC keyboard.
# * Create shortcuts to toggle between solarized dark & light:
#	- Press the '+' button:>
#		- Shortcut: Opt + Cmd + s
#		- Action: "Load Color Preset" > "Solarized Light"
#	- Press the '+' button:>
#		- Shortcut: Opt + Cmd + shift + s
#		- Action: "Load Color Preset" > "Solarized Dark"



# Logitech G700s drivers
# * https://support.logitech.com/en_us/product/g700s-rechargable-wireless-gaming-mouse/downloads#


# Karabiner elements
# Karabiner elements works much better than built-in opt<->cmd swap in system preferences because this bult-in swap does not work properly in iTerm, as alt key is only working on laptop keyboard and not on external PC keyboard.
## HOWEVER, only use if needed. If having an external mac keyboard, keep to System Preferences bindings!
# * Disable all custom modifier keys remappings done in System Preferences.
# * For all keyboard
#	* caps_lock -> escape
#	* grave_accent_and_tilde(`) -> non_us_backslash
#		* Only when having the problem that tilde key is producing ± instead. Reference: https://apple.stackexchange.com/a/367644/197493
# * For internal keyboard
#	* fn -> left_control
#	* left_control -> fn
# * For external keyboard (unless it's a proper Mac keyboard with comand and alt keys)
#	* left_command -> left_option
#	* left_option -> left_command


# Itsycal
# NOPE This is replaced with native Calendar widget!
# Preferences Save space by hiding built-in time in System Preferences > Date & Time > Clock > uncheck "Show date & time in menu bar".
## Appearance
# * Check "Use outline icon"
# * Check "Show day of week in the icon".
# * Datetime pattern: "" (as macOS clock can't be hidden starting from macOS 11).
# * Check "Show event location"
# * Check "Show calendar weeks"


# Semulov preferences
# NOPE replaced by Jettison
# NOTE Install again when https://github.com/kainjow/Semulov/issues/14 is solved, until then use ~/bin/macos_eject_external_disks.command
## Interface
# * Check "Show number of mounted in menubar"
# * Check "Show Ejec All menu item" and set the shortcut to Ctrl+Cmd+F12 or Cmd+Opt+Shift+E
## Ignore Volumes
#Recovery
#Boot OS X
#macOS Base System
#Macintosh HD - Data
## Miscellaneous
# * Launch at login

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


# restic_backup.sh
# * If running restic from cron, then it seems like giving /usr/sbin/cron (and actually not restic(1)) full disk access prevents problems like
# "scan: Open: open /Users/$USER/Desktop: operation not permitted"
# System Preferences > Security & Privacy > Privacy > Full Disk Access > add /usr/sbin/cron
## * Add an user crontab entries like:
## Environment
##SHELL=/bin/sh
## ~/ works, but not $HOME strangely enough.
#PATH=~/bin:/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/usr/bin:/bin
## Reference: crontab(5).
## Helper: https://crontab.guru/
## Order of crontab fields
## minute hour mday month wday	command
#
#
#30	 19	 *	 *	 *	if_fail_do_notification restic_backup.sh
#@monthly			   if_fail_do_notification restic_check.sh


# Stretchly
# * Turn off version update check in Preferences > About
#   until it is marked as auto_updates $(brew info stretchly)

# Dropbox
## General
# * Dropbox badge: Never show
# * Open folders in: Finder


# Denon PMA-50 (amplifier). Reference: http://manuals.denon.com/PMA50/EU/EN/WBSPSYknckyjju.php#WBSPMLurphubft
# * Connect via USB
# * Open Audio MIDI Setup app
# * Right click on PMA-50 and check "Use this Device for Sound Output"
# * Set format to: “192 kHz” and “2ch-24 bit Interger”.

# Crontab backup automation
# Add to crontab an entry like:
#@monthly			   if_fail_do_notification bak_crontab.sh

# Taskwarrior
# * Edit `~/.taskrc` to chose path for holiday files and set up remote sync server.

# Atom
# As suggested from [Stackoverflow](https://stackoverflow.com/questions/30006827/how-to-save-atom-editor-config-and-list-of-packages-installed), install frozen packages:
#apm install --packages-file ~/.atom/apm_packages_bakup.txt
# Back the installed ones up with:
#apm list --installed --bare > ~/.atom/apm_packages_bakup.txt


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

# }

# Automator Actions {
# Automator command for starting screen saver.
# 1. Open automator
# 2. Create a new service (now named Quick Action)
# 3. Choose "Run AppleScript"
# 4. In the top of the window, select for "Service receives selected" to "no input" and "in any application".
# 5. Paste contents of ~/bin/macos_start_screensaver.command so it basically becomes:
#on run {input, parameters}
	#do shell script "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"
	#return input
#end run
# 5. Save with the name "start_screensaver.
# 6. Open System Peferences>Keyboard>Shortcuts>Services>General and assign this quick action the shortcutl CTRL+CMD+L.
# If start_screensaver save did not show up, try logging in and out or restarting the computer.



# Automator command to cycle output devices. Do this for all ~/bin/macos_media_control/SwitchAudioSource*.command
# * Create an automator Quick Action named "SwitchAudioSource_cycle" with AppleScript for the contents in ~/bin/macos_media_control/SwitchAudioSource_cycle.command
# * Bind to shortcuts like:
#  - cycle: OPT+CMD+F9.
#  - Built-in: OPT+CMD+F10.
#  - PMA-50: OPT+CMD+F11.
#  - USB Soundcard/headset: OPT+CMD+F12


# Automator command eject USB drives
# * Create an automator Quick Action named "eject_external_disks" with AppleScript for the contents in ~/bin/macos_eject_external_disks.command
# * Bind to shortcut CTRL+CMD+F12


# Automator command for showing Control Center.
# TODO replace this with native System Preferences shortcut when supported.
# * Create an automator Quick Action named "open_controlcenter" with AppleScript for the contents in ~/bin/macos_open_controlcenter.command
# * Bind to shortcut CMD+F10
# * For this to work, System Preferences > Security & Privacy > Privacy > Accessibillity > allow System Preferences.app.


# Automator command for showing Now Playing
# TODO replace this with native System Preferences shortcut when supported.
# * Create an automator Quick Action named "open_nowplaying" with AppleScript for the contents in ~/bin/macos_open_nowplaying.command
# * Bind to shortcut CMD+F9
# * For this to work, System Preferences > Security & Privacy > Privacy > Accessibillity > allow System Preferences.app.

# Automator command for toggling muting microphone input
# * Create an automator Quick Action named "mic_mute_toggle" with AppleScript for the contents in ~/bin/macos_mic_mute_toggle.command
# * Bind to shortcut Kinesis Freestyle2 button right arrow (cmd+rightArrow).
# }

# Development {
# LSP Servers {
#cargo install --git https://github.com/latex-lsp/texlab.git --locked
#go get github.com/lighttiger2505/sqls
npm install -g bash-language-server
npm install -g vim-language-server
npm install -g vscode-langservers-extracted
# }

# C/C++ {
# LSP server
# brew install ccls
# }

# Go {
# LSP server
# brew install gopls
# }

# Java {
## SDKMan: https://sdkman.io/install
#curl -s "https://get.sdkman.io" | bash
#sdk install gradle x.y
#sdk install java 15.0.0.hs-adpt
# ## Brew
# See Brewfile

# LSP server
# No good one exist that are easily installable. https://microsoft.github.io/language-server-protocol/implementors/servers/
# https://github.com/eclipse/eclipse.jdt.ls is clumsy. No brew. Only hack that is not working: https://github.com/edganiukov/homebrew
# }

# Ruby {
## RVM
# NOPE replaced by ruby-build + rbenv
# Install RVM according to instructions at https://rvm.io/rvm/install
# For the gpg command, currently fails as the keyserver is not being available. Use another: https://unix.stackexchange.com/a/617320
#rvm list
#rvm install 3.0.1
#rvm --default use 3.0.1


## ruby-build + rbenv
# ruby-build install and manage different ruby versions. https://github.com/rbenv/ruby-build
# rbenv - switch to the right ruby version for projects. Autmatically uses ruby-build as install plugin. https://github.com/rbenv/rbenv
# Note env requirements at https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
#brew install ruby-build rbenv readline openssl@1.1
#rbenv init >> ~/.zshrc
#rbenv install --list
#rbenv install 3.0.2
#rbenv global 3.0.2
#
# Install global gems:
#BUNDLE_GEMFILE=${XDG_CONFIG_HOME:-$HOME/.config}/bundle/Gemfile bundle install

# Rails
# Reference: https://sergio-ildefonso.medium.com/install-ruby-and-rails-on-a-mac-7b8a1ccb5f4
# Reference: https://gorails.com/setup/osx/10.13-high-sierra
#gem install rails
## Dependencies
# sqlite - macOS version is old
#brew install sqlite3
# npm - get a node manager to manage versiosn. NVM is slow and cumbersome => n
#brew install n
#n lts
#n latest
# After switching from system node from brew, need to install my global npm packages to ~/.n/lib/node_modules/
# ~/bin/npm-install-global.sh
# yarn - better than npm
#npm install -g yarn
# NOTE unset CC=clang if creating a new rails app, as dependency byebug fails with clang.


# LSP server
#gem install --user solargraph
# }

# Python {
# * Manage python versions with pyenv from homebrew
# * Manage python projects (with dependencies) with poetry. https://github.com/python-poetry/poetry
#    * pipenv more established, but a lot of issues wih this project.
# curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
# poetry completions zsh > $XDG_CONFIG_HOME/zsh/funcs/_poetry
# and reload compinit


## jedi-vim
#cd ~/.vim/bundle/jedi-vim/
#git submodule update --init

# LSP server
#brew install pyright

## rope
#pip3 install --user ropevim
#cat >> ~/.zshrc
#export PYTHONPATH="$PYTHONPATH:$HOME/Library/Python/3.5/lib/python/site-packages"
#^D

# isort
#pip3 install --user isort
# }

# Xcode {
#* [Xvim](http://xvim.org/) Vim keybindings. See Xcode 8 [instructions](https://github.com/XVimProject/XVim/blob/master/INSTALL_Xcode8.md)
#* [stackia/solarized-xcode](https://github.com/stackia/solarized-xcode) for dark & light themes.
#* [ArtSabintsev/Solarized-Dark-for-Xcode](https://github.com/ArtSabintsev/Solarized-Dark-for-Xcode) for a (better?) dark theme.
# }
# }

# DJing {
# Serato DJ Pro:
# * Download at https://serato.com/dj/pro/downloads
# * Click the Rec buton > Set recording location to /Volumes/toshiba_music/music/sets/my_sets/serato_live_sets/
## Preferences:
### DJ Preferences
# * Check: Track End Warning
### Library + Display
# * Check: Center on selected Song
# * Played Track Color: Gray
# * Library Text Size: Step 6 out of 8
# * Check: Show Tempo Matching Display
# * Check: EQ Colored Waveforms
# * Check: Hi-Res Screen Display
# * Uncheck: Show Streaming Services
## Live stream setup: https://support.serato.com/hc/en-us/articles/360001784415-Getting-Serato-DJ-Pro-ready-to-Live-Stream
#  brew install ishowu obs
#  * Android setup: https://muddoo.com/tutorials/use-android-phone-as-a-camera-for-obs-how-to-guide/

# Djay Pro AI
## General
# * Slide Range +-: 8% # Compromise of 6% or 10%. https://www.reddit.com/r/Beatmatch/comments/c9012w/pitch_control_6_or_10_my_thoughts_and_asking_for/
#   * Do +6% for learning, the fader is so small
# * Uncheck: Reset (EQ, effect, controls)
# * Stop time: 0,0 seconds
## Devices:
# * See ~/doc/music/djing/dj_setups.txt
## Library:
# * Check: Hide unavailalbe tracks
## Appearance:
# * Fontisze: 3/4
# * Check: Show bar numbers
# * Check: Show minute markers
# * Check: Dim inactive deck

# Rekordbox
# * File browser: add Key and Comments column
# * File browser > iTunes > All Audio >  select all files > right click > Reload Tags
# * Mixer: Disable crossfader by unclicking the channels [1][2][3][4] so that it does not controll them.
## View
# * Browse - Font size: middle
# * Browse - Line space: middle
# * Layout - Tree View: keep  Related Tracks, iTunes, Explorer
# * Waveform - Color: RGB
## Controller
### Recordings tab
# * Location /Volumes/toshiba_music/music/sets/my_sets/rekordbox_live_sets/
## Advanced
### Database
# * Database Management drive: /Volumes/toshiba_music/



# Musicbrainz Picard
## Metadata
# * Remove text from "Non-album track", to not tag wit this tag when there's no found Album.
### Genres
# * Check "Use genres from musicbrainz".
## Plugins
# * Install "Amazon cover art", "Wikidata genre"
## Advanced


# iSyncr
# Set-up guide at https://www.jrtstudio.com/iSyncr/Tutorials/WiFi

# Mixedinkey
# * Download from https://account.mixedinkey.com/
## Update Tags
# * What to write: Write the key and energy level with the word Energy
# * Where to write it: In front of the comments
# * Check "Update Tempo tag"
## Export cue points
# Uncheck Traktor for fast export.

# }

# Music Production {
# Focusrite Scarlett 2i2
# * Install Focusrite control https://focusrite.com/en/focusrite-control (https://customer.focusrite.com/en/getstarted/begin)
# But prefer cask setup in Brewfile
# Bundled software at https://customer.focusrite.com/en/my-software (Nsame as https://customer.novationmusic.com/en/my-software, novation is a brand in Focusrite group).

# Akai MPKmini keyboard
# * https://www.akaipro.com/productregistration/customer/
# - Akai MPC Essentials Software  -
# - Akai MPKmini MK2 Editor - https://www.akaipro.com/productregistration/customer/
# - Air Hybrid synth


# Novation Launchkey 3
# * Set up Ableton MIDI input/output according to ~/doc/man/music/novation_launchkey_mk3_manual_v1.03.pdf page 12.
# Additional software can be found at
# * https://customer.novationmusic.com/en/my-software
# * https://customer.novationmusic.com/en/support/downloads?brand=Novation&product_by_type=1431&download_type=software



# Ableton Live
# * Download from https://www.ableton.com/en/account/
# root=/Volumes/toshiba_music/daw/
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
#  1. Keep 1 MIDI track only with brown color (drums).
#  2. Set master volume to -8dB as my headphones are very loud by default.
#  3. Set preview volume on master channels' mixer to -8dB for the same reason.
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

# Kontakt Player
# Right-click on the Rack area > In the quick-load, drag-and-drop /Volumes/toshiba_music/daw/kontakt_user_library/. Reference: https://vi-control.net/community/threads/how-do-i-add-libraries-in-kontakt-6.95343/

# }
# }

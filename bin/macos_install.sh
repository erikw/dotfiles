#!/usr/bin/env bash
# Install the macOS apps I use, using brew, cask and pip.
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=8:
# }

# TODO possibly replace this script with homebrew-bundler? https://github.com/Homebrew/homebrew-bundle


set -x

make_1line() {
	echo "$1" | tr '\n' ' '
}

# Brew lists {
read -r -d '' brew_apps_default <<-'EOAPPS'
	ack
	aspell
	bashdb
	cloc
	cmatrix
	coreutils
	cowsay
	cscope
	ctags
	curl
	dfc
	dos2unix
	elinks
	emacs
	gawk
	ghq
	git
	gnu-getopt
	gnupg
	graphviz
	htop
	httpie
	imagemagick
	ipython
	jsonlint
	knock
	links
	mercurial
	mosh
	ncdu
	netcat
	octave
	pdfgrep
	peco
	pidof
	python
	python@2
	readline
	sl
	source-highlight
	task
	tasksh
	tig
	tmux
	tree
	urlview
	vim
	watch
	wego
	wget
	zsh
	zsh-syntax-highlighting
EOAPPS
brew_apps_default=$(make_1line "$brew_apps_default")

read -r -d '' brew_apps_default_gnu <<-'EOAPPS'
	findutils
	gnu-indent
	gnu-sed
	gnu-tar
	gnutls
	grep
EOAPPS
brew_apps_default_gnu=$(make_1line "$brew_apps_default_gnu")


read -r -d '' brew_apps_additional <<-'EOAPPS'
	ffmpeg2theora
	irssi
	jq
	postgresql
	pyenv
	pyenv-virtualenvwrapper
	reattach-to-user-namespace
	swiftlint
EOAPPS
brew_apps_additional=$(make_1line "$brew_apps_additional")

# }

# Cask lists {
read -r -d '' cask_apps_default <<-'EOAPPS'
	amethyst
	appcleaner
	awareness
	caffeine
	clipy
	cyberduck
	dropbox
	electric-sheep
	firefox
	flux
	freshback
	gimp
	google-chrome
	iterm2
	itsycal
	karabiner-elements
	libreoffice
	macvim
	name-mangler
	postman
	qr-journal
	scroll-reverser
	sensiblesidebuttons
	spectacle
	spotify
	spotify-notifications
	the-unarchiver
	vlc
	wireshark
EOAPPS
cask_apps_default=$(make_1line "$cask_apps_default")


read -r -d '' cask_apps_additional <<-'EOAPPS'
	adium
	atom
	burn
	cheatsheet
	chicken
	clamxav
	colloquy
	dash
	eclipse-ide
	flip4mac
	google-backup-and-sync
	google-drive-file-stream
	gpg-suite
	handbrake
	insomnia
	intellij-idea-ce
	jing
	keepassxc
	livereload
	mactex
	max
	perian
	prey
	pycharm-ce
	robo-3t
	signal
	skim
	skype
	slack
	switch
	thunderbird
	tor-browser
	transmission
	veracrypt
	virtualbox
	xee
	yasu
EOAPPS
cask_apps_additional=$(make_1line "$cask_apps_additional")

# }

# Python lists {
# virtualenvwrapper needs to be installed for brew's pyenv-virtualenvwrapper, python2, it seems :O
read -r -d '' pip2_pkgs <<-'EOAPPS'
	virtualenvwrapper
EOAPPS
pip2_pkgs=$(make_1line "$pip2_pkgs")

read -r -d '' pip3_pkgs <<-'EOAPPS'
	ipdb
	ipython
	powerline-status
	pudb
	ropevim
EOAPPS
pip3_pkgs=$(make_1line "$pip3_pkgs")

# }

# Install {
set -e # Must be after var defs.
# Install homebrew.
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install $brew_apps_default

# Use default names for some gnu programs (which supports it), and don't get the 'g' prefix in the name.
brew install --with-default-names $brew_apps_default_gnu

#brew install $brew_apps_additional

# Make homebrew zsh default shell.
# Reference: https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

# Install rmtree for removing brew package's dependencies with $(brew rmtree <package>).
brew tap beeftornado/rmtree


# Install cask.
brew tap caskroom/cask
brew cask install $cask_apps_default
#brew cask install $cask_apps_additional

# Install older versions of apps.
brew tap caskroom/versions

# Install cask upgrade command ($ brew cu):
brew tap buo/cask-upgrade




# Macstore automation
# https://github.com/mas-cli/mas
brew install mas
# mas signin <appleId>
# Unfortunately this <appleiId> must have manually downloaded all apps one time before they can be installed with mas
# $ mas search WeatherBug
# $ mas install <id>
# To install:
# 1059074180 WeatherBug - Weather Forecasts and Alerts
# 585829637 Todoist: Organize your life
# 1147396723  WhatsApp Desktop
# 897118787  Shazam
# 405399194  Kindle



# Make a backup of installed brew packages with:
# brew bundle dump

# Install python packages.
pip2 install --user $pip2_pkgs
pip3 install --user $pip3_pkgs


# SSHFS
# Reference: https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh
brew cask install osxfuse
brew install sshfs
# Now you can mount like this:
# $ sudo mkdir -p /mnt/sshfs
# $ sudo sshfs -o allow_other,defer_permissions user@host:/ /mnt/sshfs


# Programs to install manually:
# * easytag
# * RVM: https://rvm.io/rvm/install
# * xcode XVim: https://github.com/XVimProject/XVim, https://github.com/XVimProject/XVim/blob/master/INSTALL_Xcode8.md

# Install tmux session on login.
# Reference: http://www.launchd.info/
mkdir -p $HOME/Library/LaunchAgents
cp $HOME/bin/com.user.irctor.plist $HOME/Library/LaunchAgents/
launchctl load -w $HOME/Library/LaunchAgents/com.user.irctor.plist
launchctl start com.user.irctor
#launchctl list | grep com.user.irctor
#launchctl unload -W $HOME/Library/LaunchAgents/com.user.irctor


# Start iterm2.app with tmux session loaded.
cp $HOME/bin/com.user.iterm.plist $HOME/Library/LaunchAgents/
launchctl load -w $HOME/Library/LaunchAgents/com.user.iterm.plist
launchctl start com.user.iterm


# }

# Custom/Config {

# Amethyst
# Give Amethys acessability access according to: https://ianyh.com/amethyst
# Then go to Amethys Preferences
# * Uncheck "Enable Layout HUD on Space Change".
# * Set the following layouts to be used: tall, wide, fullscreen, floating.

# Clipy
## General
# * Max clipboard size: 100
## Menu
# * Number of items to place inline: 25
# * Number of items to place inside a folder: 75
# * Number of characters in the menu: 50
## Shortcuts
# * Set the history keyboard shortcut to CTRL+Shift+F13 or Ctrl+Shift+Insert (external keyboard).

# FreshBackMac
# * Add to auto start in Settings > Users & Groups > Login items.
# * Set daily refresh
# * Turn off desktop notifications.

# Binary lastpass version, for copy-and-paste:
# https://lastpass.com/installer/?lang=en-US

# Spotify Notifications
# * Set shortcut to show current playing to: Ctrl+Opt+Shift+p or Opt+F13(print screen) or F14 (scroll lock).

# Powerline
# Install either
# * Powerline Terminus font: https://gist.github.com/creaktive/5004950#file-terminusmedium-dfont
# * Powerline Source Code Pro, Fontsize 14pt: https://github.com/powerline/fonts


# MacVim
# * Make the app quit when the last buffer is closed: " MacVim > Preferences > After the last window closes: QuitMacVim.
# * Open text files with MacVim
# 	* Find any .txt file > cmd+i on it > Open with > MacVim > Change for all

# Scroll Reerse
# Enable reverse only for Mouse, and disable from menubar.

# iTerm2
# * Make Option key an Meta key, so e.g. tmux binding works:
# Preferences > Pofiles > Keys: set "Left option key acts as" "+Esc".
# * Make it easier to restart/poweroff by not confirming closing multiple windows - I always use tmux so it's not a problem
# Perferences > General > uncheck
# 	- Confirm closing multiple sessions.
# 	- Confirm "iTerm2 (#Q)" if windows open"
# * Create shortcuts to toggle between solarized dark & light:
# 	* Preferences > Profiles > Default > Keys
# 	* Press + >
# 		- Shortcut: Opt + Cmd + s
# 		- Action: "Load Color Preset" > "Solarized Light"
# 	* Press + >
# 		- Shortcut: Opt + Cmd + shift + s
# 		- Action: "Load Color Preset" > "Solarized Dark"
#


# Automator command for starting screen saver.
# 1. Open automatos
# 2. Create a new service
# 3. Choose "Run AppleScript"
# 4. In the top of the window, select for "Service receives selected" to "no input" and "in any application".
# 5. Paste contents of ~/bin/macos_start_screensaver.command so it basically becomes:
#on run {input, parameters}
	#do shell script "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"
	#return input
#end run
# 5. Save with the name "start_screensaver.
# 6. Open System Peferences>Keyboard>Shortcuts>Services>General and assign start_screensaver the shortcutl CTRL+CMD+L.
# If start_screensaver save did not show up, try logging in and out or restarting the computer.
#
#
#
#
# # Update Keynote, Pages, Numbers & iMovie in App Store
# If these apps came preinstalled on the macbook they won't update some times as the "purchase" was made with another account. Fix with:
# 1. Create a new Apple account in App Store. Chose "None" when asked for credit card.
# 2. Uninstall all these apps from Applications expose.
# 3. Go to App Store and install all of them again, now signed in with the newly created account.


# Set up ~/bin/macos_start_screensaver.command according to instructions inside.


# * Denon PMA-50 (amplifier). Reference: http://manuals.denon.com/PMA50/EU/EN/WBSPSYknckyjju.php#WBSPMLurphubft
# 	* Connect via USB
# 	* Open Audio MIDI Setup app
# 	* Right click on PMA-50 and check "Use this Device for Sound Output"
# 	* Set format to: “192 kHz” and “2ch-24 bit Interger”.


# Logitech G700s drivers
# * https://support.logitech.com/en_us/product/g700s-rechargable-wireless-gaming-mouse/downloads#

# Karabiner elements
# Karabiner elements works much better than built-in opt<->cmd swap in system preferences because this bult-in swap does not work properly in iTerm, as alt key is only working on laptop keyboard and not on external.
# * For all keyboard
# 	* caps_lock -> escape
# * For external keyboard
#	* left_command -> left_option
#	* left_option -> left_command

# }

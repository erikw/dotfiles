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
	antiword
	aspell
	bashdb
	cloc
	cmatrix
	colordiff
	colormake
	coreutils
	cowsay
	cscope
	ctags
	curl
	daemonize
	dfc
	dos2unix
	elinks
	emacs
	gawk
	ghq
	gist
	git
	gnu-getopt
	gnupg
	go
	graphviz
	grip
	htop
	httpie
	iftop
	imagemagick
	ipcalc
	ipython
	jshon
	jsonlint
	knock
	links
	mosh
	multitail
	ncdu
	ncftp
	netcat
	nmap
	octave
	pdfgrep
	pdftotext
	peco
	pidof
	pv
	python
	python@2
	readline
	rsync
	sl
	source-highlight
	telnet
	the_silver_searcher
	tig
	tmux
	tree
	unrar
	unzip
	urlview
	vim
	w3m
	watch
	wego
	wget
	xz
	zenity
	zip
	zsh
	zsh-completions
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
	ableton-live-intro
	cgdb
	checkbashisms
	colorsvn
	cpanminus
	ffmpeg2theora
	irssi
	jq
	mercurial
	mutt
	notmuch
	offlineimap
	pastebinit
	postgresql
	pyenv
	pyenv-virtualenvwrapper
	reattach-to-user-namespace
	restic
	swiftlint
	task
	tasksh
	valgrind
EOAPPS
brew_apps_additional=$(make_1line "$brew_apps_additional")

# }

# Cask lists {
read -r -d '' cask_apps_default <<-'EOAPPS'
	amethyst
	appcleaner
	clipy
	cyberduck
	dropbox
	electric-sheep
	firefox
	freshback
	gimp
	google-chrome
	iterm2
	itsycal
	karabiner-elements
	libreoffice
	macvim
	qr-journal
	scroll-reverser
	sensiblesidebuttons
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
	flux
	awareness
	background-music
	burn
	caffeine
	cheatsheet
	clamxav
	colloquy
	dash
	eclipse-ide
	flip4mac
	franz
	google-backup-and-sync
	google-drive-file-stream
	gpg-suite
	handbrake
	insomnia
	insync
	intellij-idea-ce
	jing
	keepassxc
	livereload
	mactex
	max
	mp3tag
	name-mangler
	openvpn
	perian
	postman
	prey
	puddletag
	pycharm-ce
	rambox
	robo-3t
	signal
	skim
	skype
	slack
	spectacle
	steam
	stretchly
	switch
	thunderbird
	tor-browser
	transmission
	tunnelblick
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

read -r -d '' pip3_pkgs_additional <<-'EOAPPS'
	goobook
EOAPPS
pip3_pkgs=$(make_1line "$pip3_pkgs_additional")

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



# Let's get some fonts!
brew tap homebrew/cask-fonts
brew cask install font-terminus

brew tap colindean/fonts-nonfree
brew cask install font-microsoft-office


# Developer for Gimp can't be verified, so we need to remove an attribute that enables this check:
# Reference: https://apple.stackexchange.com/questions/216188/apps-not-opening-verifying
xattr -d com.apple.quarantine /Applications/GIMP-*.app/

# Macstore automation
# https://github.com/mas-cli/mas
brew install mas
# mas signin <appleId>
# Unfortunately this <appleiId> must have manually downloaded all apps one time before they can be installed with mas
# $ mas search WeatherBug
# $ mas install <id>
# To install:
# 585829637 Todoist: Organize your life
# 1147396723  WhatsApp Desktop
# 897118787  Shazam
# 405399194  Kindle
# 912659472  Brother ScannerApp (Image Capture.app does not work for Brother DCP-7070DW)
# 497799835  Xcode
# 402592703  Time Out - Break Reminders (2.5)
# 865500966  feedly. Read more, know more. (0.2)
# 410628904  Wunderlist: To-Do List & Tasks
# 1274495053 Microsoft To Do (2.0)
# List of previously installed
# 1059074180 WeatherBug - Weather Forecasts and Alerts



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


# Additional: cryfs
# Reference: https://www.cryfs.org/#download
# brew cask install osxfuse
# brew install cryfs


# Programs to install manually:
# * easytag
# * RVM: https://rvm.io/rvm/install
# * xcode XVim: https://github.com/XVimProject/XVim, https://github.com/XVimProject/XVim/blob/master/INSTALL_Xcode8.md
# * https://www.akaipro.com/productregistration/customer/
# - Akai MPC Essentials Software  -
# - Akai MPKmini MK2 Editor - https://www.akaipro.com/productregistration/customer/
# - Air Hybrid synth
# * Audacity: https://www.audacityteam.org/download/mac/

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

# wego from brew is not recognizing forecast.io backend.
go get -u github.com/schachmat/wego

# zsh-completions: prevent "zsh compinit: insecure directories" on $(compinit)
chmod go-w '/usr/local/share'



# Update gnu locate database on schedule by appending crontab.
#newtab="* */2 * * * /usr/local/Cellar/findutils/4.6.0/bin/updatedb --prunepaths='/tmp' >/dev/null 2>&1"
newtab="* */2 * * * /usr/local/Cellar/findutils/4.6.0/bin/updatedb --localpaths='/etc $HOME' >/dev/null 2>&1"
oldtab=$(sudo crontab -l)
if [ -n "$oldtab" ]; then
	newtab=$(printf "%s\n%s\n" "$oldtab" "$newtab")
fi
sudo sh -c "echo \"$newtab\" | crontab -"



# Brother DCP-7070dw printer & scanner driver: https://support.brother.com/g/b/downloadtop.aspx?c=eu_ot&lang=en&prod=dcp7070dw_eu
# Add by Bonjour discovery on network.


# Antivirus: Avast Security for Mac
# https://www.avast.com/en-us/free-mac-security

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
## General
# * Make it easier to restart/poweroff by not confirming closing multiple windows - I always use tmux so it's not a problem.  Unckeck:
# - Confirm closing multiple sessions.
# - Confirm "iTerm2 (#Q)" if windows open"
# * iterm.sh: If iterm2.app is closed, 2 windows will be opended by this script. To prevent this:
# 	- Startup > Select "Only Restore Hotkey Window"
# * Enable automatic tmux copy to GUI clipboard on selection
# - Check "Applications in terminal may access clipboard"
## Profiles
### Colors
# * Select color preset "Solarized Dark".
### Text
# * Set font to Source Code Pro for Powerline, 14pt.
### Terminal
# * Check "Unlimited Scrollback"
### Keys
# * Make Option key an Meta key, so e.g. tmux binding works:
#   - set "Left option key acts as" "+Esc". NOTE need karabiner-elements to get left alt to work on external keyboard.
# * Create shortcuts to toggle between solarized dark & light:
# 	- Press the '+' button:>
# 		- Shortcut: Opt + Cmd + s
# 		- Action: "Load Color Preset" > "Solarized Light"
# 	- Press the '+' button:>
# 		- Shortcut: Opt + Cmd + shift + s
# 		- Action: "Load Color Preset" > "Solarized Dark"


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


# Serato DJ Pro: https://serato.com/dj/pro/downloads

# Logitech G700s drivers
# * https://support.logitech.com/en_us/product/g700s-rechargable-wireless-gaming-mouse/downloads#

# Karabiner elements
# Karabiner elements works much better than built-in opt<->cmd swap in system preferences because this bult-in swap does not work properly in iTerm, as alt key is only working on laptop keyboard and not on external.
# * Disable all custom modifier keys remappings done in System Preferences.
# * For all keyboard
# 	* caps_lock -> escape
# * For internal keyboard
# 	* fn -> left_control
# 	* left_control -> fn
# * For external keyboard
#	* left_command -> left_option
#	* left_option -> left_command


# Itsycal
# Preferences Save space by hiding built-in time in System Preferences > Date & Time > Clock > uncheck "Show date & time in menu bar".
## * Check "Show day of week in the icon".
## * Datetime pattern: HH:mm

# }

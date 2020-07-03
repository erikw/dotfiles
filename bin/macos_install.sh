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
read -r -d '' brew_formulae_default <<-'EOAPPS'
	ack
	aspell
	cloc
	cmatrix
	colordiff
	colormake
	coreutils
	cowsay
	cscope
	ctags
	curl
	dfc
	dos2unix
	findutils
	gawk
	ghq
	git
	gnu-getopt
	gnu-indent
	gnu-sed
	gnu-tar
	gnupg
	gnutls
	go
	graphviz
	grep
	grip
	htop
	iftop
	imagemagick
	ipcalc
	jq
	jshon
	macvim
	mosh
	ncdu
	netcat
	nmap
	octave
	pdfgrep
	pdftotext
	pidof
	python
	readline
	rsync
	sl
	source-highlight
	switchaudio-osx
	telnet
	tig
	tmux
	tree
	unrar
	unzip
	urlview
	w3m
	watch
	wget
	xz
	zenity
	zip
	zsh
	zsh-completions
	zsh-syntax-highlighting
EOAPPS
brew_formulae_default=$(make_1line "$brew_formulae_default")

# Formulae notes
# * macvim - install 'formulae macvim' because:
# ** it provides MacVim.app in /usr/local/Cellar/macvim/<version number>/. See https://arophix.com/2018/01/24/install-vim-on-macos-high-sierra/
# ** 'cask macvim' includes only dynamically lined python. $(vim --version) gives +python3/dyn and that does not find powerline.
# ** 'formulae macvim' has $(vim --version) "+python3"
# ** macOS search (cmd+space) still find MacVim.app in the Cellar
# ** 'formulae vim' does not include MacVim.app
# ** having both formula vim/macvim + cask macvim causes symlink overwrite problems on upgrade ($brew link vim/macvim).
# * python@2 - needed for ~/bin/com.user.iterm.plist to be able to start powerline for tmux. Even though powerline-status py package is installed for python3 only, it's still needed somehow.



# NOTE typically just pyenv is okay. pyenv-virtualenvwrapper is only needed for projects with python <3.3
# see https://www.freecodecamp.org/news/manage-multiple-python-versions-and-virtual-environments-venv-pyenv-pyvenv-a29fb00c296f/
read -r -d '' brew_formulae_additional <<-'EOAPPS'
	ableton-live-suite
	antiword
	bashdb
	cgdb
	checkbashisms
	cmake
	colorsvn
	cpanminus
	daemonize
	elinks
	emacs
	ffmpeg2theora
	httpie
	ipython
	irssi
	jsonlint
	knock
	mercurial
	multitail
	mutt
	ncftp
	nethogs
	notmuch
	offlineimap
	openvpn
	pastebinit
	peco
	postgresql
	pv
	pyenv
	pyenv-virtualenvwrapper
	python@2
	reattach-to-user-namespace
	restic
	swiftlint
	task
	tasksh
	the_silver_searcher
	valgrind
	wakeonlan
	wego
EOAPPS
brew_formulae_additional=$(make_1line "$brew_formulae_additional")

# }

# Cask lists {
read -r -d '' brew_casks_default <<-'EOAPPS'
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
	scroll-reverser
	semulov
	sensiblesidebuttons
	spotify
	spotify-notifications
	the-unarchiver
	vlc
EOAPPS
brew_casks_default=$(make_1line "$brew_casks_default")

read -r -d '' brew_casks_additional <<-'EOAPPS'
	adium
	android-platform-tools
	atom
	authy
	awareness
	background-music
	bankid
	burn
	caffeine
	cheatsheet
	clamxav
	colloquy
	dash
	eclipse-ide
	epic-games
	flip4mac
	flux
	franz
	google-backup-and-sync
	google-drive-file-stream
	gpg-suite
	gramps
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
	origin
	perian
	postman
	prey
	puddletag
	pycharm-ce
	qr-journal
	rambox
	robo-3t
	signal
	skim
	skype
	slack
	spectacle
	steam
	steam
	stretchly
	switch
	thunderbird
	tor-browser
	transmission
	tunnelblick
	veracrypt
	virtualbox
	wireshark
	xee
	yasu
EOAPPS
brew_casks_additional=$(make_1line "$brew_casks_additional")

# }

# Python lists {
#read -r -d '' pip2_pkgs <<-'EOAPPS'
#EOAPPS
#pip2_pkgs=$(make_1line "$pip2_pkgs")

read -r -d '' pip3_pkgs <<-'EOAPPS'
	ipython
	virtualenvwrapper
EOAPPS
pip3_pkgs=$(make_1line "$pip3_pkgs")

read -r -d '' pip3_pkgs_additional <<-'EOAPPS'
	goobook
	ipdb
	powerline-status
	pudb
	ropevim
EOAPPS
pip3_pkgs_additional=$(make_1line "$pip3_pkgs_additional")

# }

# Install {
set -e # Must be after var defs.
# Install homebrew.
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Note that some gnu pakcages comes with g-prefix in the bin names. The default names are set up in $PATH in ~/.shell_commons
brew install $brew_formulae_default

#brew install $brew_formulae_additional

# Make homebrew zsh default shell.
# Reference: https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

# Install rmtree for removing brew package's dependencies with $(brew rmtree <package>).
brew tap beeftornado/rmtree


# Install cask.
brew tap caskroom/cask
brew cask install $brew_casks_default
#brew cask install $brew_casks_additional

# Install cask upgrade command ($ brew cu):
brew tap buo/cask-upgrade



# Let's get some fonts!
brew tap homebrew/cask-fonts
brew cask install font-terminus font-source-code-pro font-inconsolata

brew tap colindean/fonts-nonfree
brew cask install font-microsoft-office

# Automatic upgrades
# Reference: https://github.com/DomT4/homebrew-autoupdate
brew tap domt4/autoupdate
brew install terminal-notifier
# Start upgrade (including casks) every 12 hours.
brew autoupdate --start 43200 --upgrade --cleanup --enable-notification
brew autoupdate --status

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
# 428799479 - GamePad Companion



# Make a backup of installed brew packages with:
# brew bundle dump

# Install python packages.
#pip2 install --user $pip2_pkgs
pip3 install --user $pip3_pkgs
#pip3 install --user $pip3_pkgs_additional


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
# NOTE disabled as updatedb takes too much CPU on macOS, making other work hard.
#newtab="* */2 * * * /usr/local/Cellar/findutils/4.6.0/bin/updatedb --localpaths='/etc $HOME' >/dev/null 2>&1"
#oldtab=$(sudo crontab -l)
#if [ -n "$oldtab" ]; then
	#newtab=$(printf "%s\n%s\n" "$oldtab" "$newtab")
#fi
#sudo sh -c "echo \"$newtab\" | crontab -"



# Brother DCP-7070dw printer & scanner driver: https://support.brother.com/g/b/downloadtop.aspx?c=eu_ot&lang=en&prod=dcp7070dw_eu
# Add by Bonjour discovery on network.


# Antivirus: Avast Security for Mac
# https://www.avast.com/en-us/free-mac-security


# BankId på fil
# Instructions: https://swedbank.se/privat/digitala-tjanster/mobilt-bankid/bankid-pa-kort-och-fil/bankid-pa-fil.html
# Install: https://install.bankid.com/ or cask

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
# * Set the history keyboard shortcut to Cmd+Shift+v.

# FreshBackMac
# * Add to auto start in Settings > Users & Groups > Login items.
# * Set daily refresh
# * Turn off desktop notifications.

# Binary lastpass version, for copy-and-paste:
# https://lastpass.com/installer/?lang=en-US

# Spotify Notifications
# * Set shortcut to show current playing to: Ctrl + Opt + Cmd + p

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
### General
# * If a new login shell with zsh gives $?=1, avoid this by chaning Command to "zsh" instead of "Login Shell". TODO remove this when the mysterious bug has disappeared.
### Colors
# * Select color preset "Solarized Dark".
### Text
# * Set font to either
# ** Source Code Pro for Powerline, 14pt.
# ** Source Code Pro, Regular, 14pt
# ** Terminus, Medium, 16pt
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
# 6. Open System Peferences>Keyboard>Shortcuts>Services>General and assign start_screensaver the shortcutl CTRL+CMD+L.
# If start_screensaver save did not show up, try logging in and out or restarting the computer.
#
#
#
#
#
#
#
# Automator command to cycle output devices. Do this for all ~/bin/macos_media_control/SwitchAudioSource*.command
# 1. Open automator
# 2. Create a new service (now named Quick Action)
# 3. Choose "Run AppleScript"
# 4. In the top of the window, select for "Service receives selected" to "no input" and "in any application".
# 5. Paste contents of ~/bin/macos_media_control/SwitchAudioSource_cycle.command
# 5. Save with the name "SwitchAudioSource_cycle".
# 6. Open System Peferences>Keyboard>Shortcuts>Services>General and assign SwitchAudioSource_* to the shortcut
#  cycle: OPT+CMD+F9.
#  Built-in: OPT+CMD+F10.
#  PMA-50: OPT+CMD+F11.
#  USB Soundcard/headset: OPT+CMD+F12
#
#
#
# Automator command eject USB drives
# * Create an automator Quick Action with AppleScript for the contents in ~/bin/macos_eject_external_disks.command
# * Bind to shortcut CTRL+CMD+F12
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
# 	* grave_accent_and_tilde(`) -> non_us_backslash
# 		* Only when having the problem that tilde key is producing ± instead. Reference: https://apple.stackexchange.com/a/367644/197493
# * For internal keyboard
# 	* fn -> left_control
# 	* left_control -> fn
# * For external keyboard (unless it's a proper Mac keyboard with comand and alt keys)
#	* left_command -> left_option
#	* left_option -> left_command


# Itsycal
# Preferences Save space by hiding built-in time in System Preferences > Date & Time > Clock > uncheck "Show date & time in menu bar".
## * Check "Show day of week in the icon".
## * Datetime pattern: HH:mm

# Mullvad
# https://mullvad.net/en/download/


# Semulov preferences
## Interface
# * Check "Show number of mounted in menubar"
# * Check "Show Ejec All menu item" and set the shortcut to Ctrl+Cmd+F12
## Ignore Volumes
# * Enter "Recovery"
## Miscellaneous
# * Launch at login

# }

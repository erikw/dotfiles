# Brewfile for general base systems. Host specifics can be found in .Brewfile.$HOSTNAME files.
# Manual: https://docs.brew.sh/Manpage#bundle-subcommand
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 ft=brewfile:
#	The syntax highlight via vim plugin https://github.com/bfontaine/Brewfile.vim
# }

# Taps {
	tap 'beeftornado/rmtree' # rmtree: remove brew package's dependencies with $(brew rmtree <package>).
	tap 'homebrew/autoupdate' # https://github.com/Homebrew/homebrew-autoupdate
# }

# Formula: default {
	brew 'ack'
	brew 'aspell'
	brew 'bash'
	brew 'cloc'
	brew 'cmatrix'
	brew 'colordiff'
	brew 'coreutils'	# Note that some gnu pakcages comes with g-prefix in the bin names. The default names are set up in $PATH in ~/.shell_commons
	brew 'cowsay'
	brew 'curl'
	brew 'dfc'
	brew 'dos2unix'
	brew 'findutils'
	brew 'fswatch'		# For macos_appearance_monitor.sh
	brew 'gawk'
	brew 'ghq'
	brew 'git'
	brew 'gnu-getopt'
	brew 'gnu-indent'
	brew 'gnu-sed'
	brew 'gnu-tar'
	brew 'gnupg'
	brew 'gnutls'
	brew 'graphviz'
	brew 'grep'
	brew 'grip'
	brew 'htop'
	brew 'iftop'
	brew 'imagemagick'
	brew 'ipcalc'
	brew 'jq'
	brew 'ncdu'
	brew 'netcat'
	brew 'nmap'
	brew 'npm'
	brew 'octave'
	brew 'pdfgrep'
	brew 'peco'
	brew 'pidof'
	brew 'python'
	brew 'readline'
	brew 'rename'		# aka rename.pl
	brew 'rsync'
	brew 'sl'
	brew 'source-highlight'
	brew 'switchaudio-osx'
	brew 'telnet'
	brew 'texlab' # Language server for LaTeX
	brew 'tig'
	brew 'tmux'
	brew 'tree'
	brew 'unar'
	brew 'unzip'
	brew 'urlview'		# for tmux link opening
	brew 'w3m'
	brew 'watch'
	brew 'wget'
	brew 'xz'
	brew 'zip'
	brew 'zsh'
	brew 'zsh-completions'
	brew 'zsh-syntax-highlighting'
# }

# Formula: optional {
=begin
	brew 'antiword'
	brew 'bashdb'
	brew 'cgdb'
	brew 'checkbashisms'
	brew 'cmake'
	brew 'colormake'
	brew 'colorsvn'
	brew 'cpanminus'
	brew 'cscope'
	brew 'ctags'
	brew 'daemonize'
	brew 'elinks'
	brew 'emacs'
	brew 'ffmpeg2theora'
	brew 'go'
	brew 'httpie'
	brew 'irssi'
	brew 'jsonlint'
	brew 'knock'
	brew 'mercurial'
	brew 'mosh'
	brew 'multitail'
	brew 'mutt'
	brew 'ncftp'
	brew 'nethogs'
	brew 'node'
	brew 'notmuch'
	brew 'offlineimap'
	brew 'openvpn'
	brew 'pastebinit'
	brew 'postgresql'
	brew 'pv'
	brew 'pyenv'
	brew 'pyenv-virtualenvwrapper'
	brew 'reattach-to-user-namespace'
	brew 'ruby'
	brew 'swiftlint'
	brew 'task'
	brew 'tasksh'
	brew 'the_silver_searcher'
	brew 'tigervnc-viewer'
	brew 'valgrind'
	brew 'wakeonlan'
	brew 'wego'
	brew 'zenity'
=end
# }


# Cask: default {
	cask 'amethyst'
	cask 'appcleaner'
	cask 'clipy'
	cask 'electric-sheep'
	cask 'firefox'
	cask 'gimp'
	cask 'google-chrome'
	cask 'iterm2'
	cask 'libreoffice'
	cask 'macvim'	# Prefer macvim cask to formula. Both provide MacVim.app but only the cask installs it to /Applications. Spotlight used to find both locations, but no only at /Applications. https://github.com/macvim-dev/macvim/issues/450#issuecomment-570202139
	cask 'scroll-reverser'
	cask 'sensiblesidebuttons'	# Need to manually add it to System Preferences > Users & Groups > Login items
	cask 'spotify'
	cask 'the-unarchiver'
	cask 'vlc'
# }

# Cask: optional {
=begin
	cask 'adium'
	cask 'android-studio'
	cask 'atom'
	cask 'audacity'
	cask 'audio-hijack'
	cask 'awareness'
	cask 'background-music'
	cask 'bankid'
	cask 'burn'
	cask 'caffeine'
	cask 'cheatsheet'
	cask 'clamxav'
	cask 'colloquy'
	cask 'cyberduck'
	cask 'dash'
	cask 'docker'
	cask 'eclipse-ide'
	cask 'epic-games'
	cask 'eqmac'
	cask 'fl-studio'
	cask 'flip4mac'
	cask 'flux'
	cask 'franz'
	cask 'freshback'
	cask 'google-drive'
	cask 'gpg-suite'
	cask 'handbrake'
	cask 'insomnia'
	cask 'insync'
	cask 'intellij-idea-ce'
	cask 'itsycal'
	cask 'jing'
	cask 'karabiner-elements'
	cask 'keepassxc'
	cask 'keybase'
	cask 'livereload'
	cask 'max'
	cask 'microsoft-excel'
	cask 'microsoft-outlook'
	cask 'microsoft-powerpoint'
	cask 'microsoft-word'
	cask 'mp3tag'
	cask 'name-mangler'
	cask 'origin'
	cask 'pdftotext'
	cask 'perian'
	cask 'postman'
	cask 'prey'
	cask 'pycharm-ce'
	cask 'qr-journal'
	cask 'rambox'
	cask 'rekordbox'
	cask 'robo-3t'
	cask 'semulov'
	cask 'send-to-kindle'
	cask 'skim'
	cask 'skype'
	cask 'slack'
	cask 'sound-control'
	cask 'spectacle'
	cask 'spotify-notifications'
	cask 'steam'
	cask 'stretchly'
	cask 'switch'	 # Audio format converter
	cask 'thunderbird'
	cask 'tor-browser'
	cask 'tunnelblick'
	cask 'veracrypt'
	cask 'virtualbox'
	cask 'wireshark'
	cask 'xee'
	cask 'yasu'
	cask 'zoom'
=end
# }

# Mas: default {
# https://github.com/mas-cli/mas
# Format: mas "Human Readable Name Can Be Whatever", id:<id>
# Unfortunately this <appleiId> must have manually downloaded all apps one time before they can be installed with mas. Find <id> with
# $ mas search <app>
	mas  'Brother iPrint&Scan', id: 1193539993  # Image Capture.app does not work for Brother DCP-7070DW
	mas  'Shazam', id: 897118787
	mas  'Todoist', id: 585829637
# }

# Mas: optional {
=begin
	mas 'GamePad Companion', id: 428799479
	mas 'Irvue', id: 1039633667
	mas 'Microsoft To Do', id: 1274495053
	mas 'MuteMyMic', id: 456362093
	mas 'Neural Mix Pro', id: 1527105121
	mas 'SwordSoft Screenink Free', id: 953841977
	mas 'WeatherBug', id: 1059074180
	mas 'WhatsApp Desktop', id: 1147396723
	mas 'Xcode', id: 497799835
=end
# }

# Development: Java {
=begin
	brew 'java'
	brew 'maven'
	brew 'gradle'
	brew 'ant'

	tap 'adoptopenjdk/openjdk'
	brew 'adoptopenjdk11'
=end
# }

# Development: Python {
=begin
	brew 'ipython'
	brew 'pyright' # Language Server for python https://langserver.org/
	brew 'python@2'
=end


# Misc {
# cryfs {
# Reference: https://www.cryfs.org/#download https://github.com/cryfs/cryfs
#cask 'osxfuse'
#brew 'cryfs/tap/cryfs'
# }

# Fonts {
	tap 'homebrew/cask-fonts'
	cask 'font-terminus'
	cask 'font-inconsolata'
	brew 'svn' # Dependency for font'source-code-pro
	cask 'font-source-code-pro'

	tap 'colindean/fonts-nonfree'
	cask 'font-microsoft-office'
# }

# SSHFS {
# Reference: https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh
#brew 'osxfuse'
#brew 'sshfs'
# Now you can mount like this:
# $ sudo mkdir -p /mnt/sshfs
# $ sudo sshfs -o allow_other,defer_permissions user@host:/ /mnt/sshfs
# }

# }

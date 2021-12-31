# Dotfiles

Most of my personal dotfiles can be found in this branch. I use dfm (dot file manager) to install and managed the dotfiles. See [justone/dotfiles](https://github.com/justone/dotfiles) & [justone/dfm](https://github.com/justone/dfm) for details on how to use it.

# Highlights
* [.config/](.config/) - I've spent quite some effort to make my dotfiles adhere to the [XDG](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) Base Directory Standard as much as possible, using and contributing to the [Arch wiki page](https://wiki.archlinux.org/title/XDG_Base_Directory). As far from all programs that I use support this natively, quite some custom configuration neeeded to be done. Grep for `XDG` in [.config/shell/commons](.config/shell/commons).
* Check out my Neovim configurations [.config/nvim/](.config/nvim)-- they are pretty cool!
* [bin/](bin/) -- many handy and time saving scripts.
  * [pdf_compress.sh](bin/pdf_compress.sh) -- compress file size of PDFs!

# Installation

## OS Dependent Tooling
The dotfiles will work without the base tooling, but much better if it's already in place!

### macOS
For macOS, install homebrew and run configs:
```bash
bin/macos_config.sh
bin/macos_install.sh
```

### Windows
Run :
```bash
bin/windows_config.ps1
bin/windows_install.ps1
```


## Git

### Generate a pair of new SSH keys for GitHub
```bash
$ cd /tmp
$ curl -O https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/ssh-keygen.sh
$ chmod 744 ssh-keygen.sh
$ ./ssh-keygen.sh
```

Add a config for GitHub, but don't bother about the values. Instead after this open up `~/.ssh/config` and remove the newly added github section and replace it with

```
Host *github.com
	Port 22
	User git
	IdentityFile ~/.ssh/identityfiles/github_id_rsa
	IdentitiesOnly yes
	ServerAliveInterval 15
```


### Upload keys
Upload the public key to your [GitHub profile](https://github.com/settings/keys)

```bash
# Linux:
$ xclip ~/.ssh/identityfiles/github_id_rsa.pub
$ # or, macOS:
$ pbcopy <  ~/.ssh/identityfiles/github_id_rsa.pub
```

### Set Git Email
Needs to be set for GitHub to [associate](https://docs.github.com/en/github/setting-up-and-managing-your-github-user-account/managing-email-preferences/setting-your-commit-email-address) commits.

Set up git user email address in `~/.config/git/config-local`:
```
[user]
	email = user@doman.tld
```


## Install DFM

```bash
$ #git clone git@github.com:erikw/dotfiles.git ~/.dotfiles  # old
$ git clone git@github.com:erikw/dotfiles.git ~/src/github.com/erikw/dotfiles
$ cd !$
$ ./install.sh
```

Check what dotfiles that were overriden, and handle this with a merge or discard.
```bash
$ cd ~/.backup
$ ls -la
```

Switch to a local branch for secret changes:

```bash
$ cd ~/.dotfiles
$ git checkout -b local
```
and after making some changes to the branch, star quashing to one commit
```bash
$ git commit -m "SQUASHED passwords"
```


## Host specific configuration
* Passwords and other secretes are censored. To find these and substitue them for the real thing, do:
	```console
	$ grep -nr GIT-CENSORED . | grep -v README.md | grep -v "/.git/"
	```
* Set `DESKTYPE` in `$XDG_CONFIG_HOME/shell/commons`, unless system is macos.
* Default desktop is assumed to be macOS. Go through host-specific manual settings by searching for the corresponding tag.
	```console
	$ grep -nr MACOS-CONFIG . 2>/dev/null | grep -v README.md
	$ grep -nr LINUX-CONFIG . 2>/dev/null | grep -v README.md
	$ grep -nr FREEBSD-CONFIG . 2>/dev/null | grep -v README.md
	```


## Firefox
Import minimal search-keyword bookmarks from [bookmarks_minimal.html](.config/mozilla/bookmarks_minimal.html) to Firefox.

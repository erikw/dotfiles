# Dotfiles

Most of my personal dotfiles can be found in this branch. I use dfm (dot file manager) to install and managed the dotfiles. See [justone/dotfiles](https://github.com/justone/dotfiles) & [justone/dfm](https://github.com/justone/dfm) for details on how to use it.

# Highlights
* [.config/](.config/) - I've spent quite some effort to make my dotfiles adhere to the [XDG](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) Base Directory Standard as much as possible, using and contributing to the [Arch wiki page](https://wiki.archlinux.org/title/XDG_Base_Directory). As far from all programs that I use support this natively, quite some custom configuration neeeded to be done. Grep for `XDG` in [.config/shell/commons](.config/shell/commons).
* Check out my Neovim configurations [.config/nvim/](.config/nvim)-- they are pretty cool!
* [bin/](bin/) -- many handy and time saving scripts.
  * [pdf_compress.sh](bin/pdf_compress.sh) -- compress file size of PDFs!

# Development 
# Installation

## Install DFM

### Bootstrapped
Either bootstrap like:
```console
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/bootstrap_dotfiles.sh)"
```

### Manual
#### Git
##### Generate a pair of new SSH keys for GitHub
```console
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


##### Upload keys
Upload the public key to your [GitHub profile](https://github.com/settings/keys)

```console
# Linux:
$ xclip ~/.ssh/identityfiles/github_id_rsa.pub
$ # or, macOS:
$ pbcopy <  ~/.ssh/identityfiles/github_id_rsa.pub
```

##### Git E-Mail
Set up git user email address in `~/.config/git/config-local`:
```
[user]
	email = user@doman.tld
```
#### Clone dotfiles repo
* Clone repo
```console
$ #git clone git@github.com:erikw/dotfiles.git ~/.dotfiles  # old
$ git clone git@github.com:erikw/dotfiles.git ~/src/github.com/erikw/dotfiles
$ cd !$
$ ./install.sh
```




## OS Dependent Tooling
The dotfiles will work without the base tooling, but much better if it's already in place!

### macOS
For macOS, install homebrew and run configs:
```console
$ bin/macos_config.sh
$ bin/macos_install.sh
```

### Windows
Run:
```console
$ bin/windows_config.ps1
$ bin/windows_install.ps1
```




## Dotfiles setup
Now it's time make the final configurations to the dotfiles repo itself once the OS-dependant tooling is setup:
```console
$ ./install.sh
```

### Post-install
Check what dotfiles that were overriden, and handle this with a merge or discard.
```console
$ cd ~/.backup
$ ls -la
```

Switch to a local branch for secret changes:
```console
$ cd ~/.dotfiles
$ git checkout -b local
```

and after making some changes to the branch, squash to one commit
```console
$ git commit -m "SQUASHED passwords"
```

### Host specific configuration
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

# Future
* Migrate to [homeschick](https://github.com/andsens/homeshick) to be able to split Linux from macOS-only configs, and have a main general one?
* Could replace dfm with GNU stove: https://www.stevenrbaker.com/tech/managing-dotfiles-with-gnu-stow.html ?


# Dotfiles

Most of my personal dotfiles can be found in this branch. I use dfm (dot file manager) to install and managed the dotfiles. See [justone/dotfiles](https://github.com/justone/dotfiles) for details on how to use it.

<!-- toc -->

- [Highlights](#highlights)
- [Installation](#installation)
  * [Set up Github credentials](#set-up-github-credentials)
    + [Generate a pair of new SSH keys.](#generate-a-pair-of-new-ssh-keys)
    + [Upload keys](#upload-keys)
  * [Install DFM](#install-dfm)
  * [Host specific configuration](#host-specific-configuration)
  * [Install ghq](#install-ghq)
  * [General](#general)
  * [rvm](#rvm)
  * [Vim](#vim)
    + [Compile command-t](#compile-command-t)
    + [jcommenter](#jcommenter)
    + [vim-instant-markdown](#vim-instant-markdown)
    + [Python development](#python-development)
      - [jedi-vim](#jedi-vim)
      - [rope](#rope)
      - [isort](#isort)
  * [MacVim](#macvim)
  * [Tmux](#tmux)
  * [ZSH/Bash](#zshbash)
  * [ZSH](#zsh)
  * [Xcode](#xcode)
  * [Intellij/PyCharm/PhpStorm](#intellijpycharmphpstorm)
  * [Taskwarrior](#taskwarrior)
  * [Firefox](#firefox)
  * [SDK manager](#sdk-manager)
  * [Atom](#atom)
- [Table of Contents generation](#table-of-contents-generation)

<!-- tocstop -->

# Highlights

 * Check out my vim configurations -- they are pretty cool!
 * [bin/](bin/) -- many handy and time saving scripts.

# Installation

## Set up Github credentials

### Generate a pair of new SSH keys.
```bash
$ cd /tmp
$ curl -O https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/ssh-keygen.sh
$ chmod 744 ssh-keygen.sh
$ ./ssh-keygen.sh
```

Add a config for Github, but don't borther about the values. Instead after this open up `~/.ssh/config` and remove the newly added github section and replace it with

```
Host *github.com
	Port 22
	User git
	IdentityFile ~/.ssh/identityfiles/github_id_rsa
	IdentitiesOnly yes
	ServerAliveInterval 15
```

### Upload keys
Upload the public key to your [Github profile](https://github.com/settings/keys)

```bash
# Linux:
$ xclip ~/.ssh/identityfiles/github_id_rsa.pub
$ # or, macOS:
$ pbcopy <  ~/.ssh/identityfiles/github_id_rsa.pub
```


## Install DFM

```bash
$ git clone git@github.com:erikw/dotfiles.git ~/.dotfiles
$ cd !$
$ git submodule init
$ git submodule update
$ bin/dfm install
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

Untrack `~/.irssi/config` for local changes.

```bash
$ source ~/.shell_aliases
$ dotf_irssiconf_untrack
```


## Host specific configuration
Passwords and other secretes are censored. To find these and substitue them for the real thing, do

```bash
$ grep -nr GIT-CENSORED . | grep -v README.md
```


Set `DESKTYPE` in `~/.shell_commons`, unless system is macos.

If the host system is macOS, then at some places manual configuration is needed. Find where by looking for the macOS tag:
```bash
$ grep -nr MACOS-CONFIG . | grep -v README.md
```

same for FreeBSD:
```bash
$ grep -nr FREEBSD-CONFIG . | grep -v README.md
```


For macOS, install homebrew and run configs:

```bash
~/bin/macos_config.sh
~/bin/macos_install.sh
```

## Install ghq
Make it easier to organize all git clones that will follow soon, by using the exellent tool [ghq](https://github.com/motemen/ghq)!

```bash
$ go get github.com/motemen/ghq
```

## General

* [altercation/solarized](https://github.com/altercation/solarized)
```bash
$ cd ~/src
$ git clone git@github.com:altercation/solarized.git
````


## rvm
Install latest [ruby version environment](https://rvm.io/rvm/install). The pro of doing this is that `~/.shell_commons` adds the installed GEMs to PATH e.g. flavio/jump.
```bash
$ \curl -sSL https://get.rvm.io | bash -s stable --ruby
$ #rvm install ruby --latest # already done by the curl-install.
$ rvm list
```


## Vim

```bash
$ vim -c BundleInstall
```

### Compile command-t
```bash
$ cd ~/.vim/bundle/command-t/ruby/command-t/ext/command-t
$ ruby extconf.rb
$ make   # FreeBSD: use gmake.
````

### jcommenter
The plugin uses DOS line endings; convert it.
```bash
$ dos2unix ~/.vim/bundle/jcommenter.vim/plugin/jcommenter.vim
````

### [vim-instant-markdown](https://github.com/suan/vim-instant-markdown)
```bash
$ sudo npm -g install instant-markdown-d
````

### Python development
#### jedi-vim
```bash
$ cd ~/.vim/bundle/jedi-vim/
$ git submodule update --init
````

#### rope
```bash
$ pip3 install --user ropevim
$ cat >> ~/.zshrc
export PYTHONPATH="$PYTHONPATH:$HOME/Library/Python/3.5/lib/python/site-packages"
^D
````

#### isort
```bash
$ pip3 install --user isort
````





## MacVim
* Install [Inconsolata](https://github.com/google/fonts/tree/master/ofl/inconsolata) font which my [.gvimrc](.gvimrc) is set up with.

## Tmux

Install:

 * [powerline](https://powerline.readthedocs.io/en/latest/installation.html)
 * urlview(1)
 * [seebi/tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized)
 ```bash
 $ cd ~/src
 $ git clone git@github.com:seebi/tmux-colors-solarized.git
 ```
 * ~~`brew install reattach-to-user-namespace` if on OSX~~
 * [tpm](https://github.com/tmux-plugins/tpm)
```bash
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
````
Then reload tmux.conf

```
$ tmux source ~/.tmux.conf
```
and press `prefix-I` to install tpm plugins.


Update `~/.tmux.conf` to use xclip for linux and pbcopy/pbpaste for macOS and the default-command option.


## ZSH/Bash

Install for both:
 * [seebi/dircolors-solarized](https://github.com/seebi/dircolors-solarized) (only for Linux systems)
 * [GNU source-highlight](https://www.gnu.org/software/src-highlite/source-highlight.html) for less(1).
 * [jrunning/source-highlight-solarized](https://github.com/jrunning/source-highlight-solarized)

```bash
$ ghq get git@github.com:jrunning/source-highlight-solarized.git
$ datadir=$(yes n | source-highlight-settings | grep "current datadir" | sed -e 's/^.*: //')
$ cp ~/src/github.com/jrunning/source-highlight-solarized/esc-solarized.* $datadir
$ echo "esc-solarized = esc-solarized.outlang" >> $datadir/outlang.map
````


 * [flavio/jump](https://github.com/flavio/jump)
```bash
$ gem install --user-install jump
$ cd ~/.dotfiles
$ s dot
$ cd ~/dl/
$ s dl
````

## ZSH
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)


## Xcode
* [Xvim](http://xvim.org/) Vim keybindings. See Xcode 8 [instructions](https://github.com/XVimProject/XVim/blob/master/INSTALL_Xcode8.md)
* [stackia/solarized-xcode](https://github.com/stackia/solarized-xcode) for dark & light themes.
* [ArtSabintsev/Solarized-Dark-for-Xcode](https://github.com/ArtSabintsev/Solarized-Dark-for-Xcode) for a (better?) dark theme.

## Intellij/PyCharm/PhpStorm
* [Intellij solarized](https://github.com/jkaving/intellij-colors-solarized)

## Taskwarrior
Edit `~/.taskrc` to chose path for holiday files and set up remote sync server.


## Firefox
Import minimal search-keyword bookmarks from [.bookmarks_minimal.html](.bookmarks_minimal.html) to Firefox.

## SDK manager
Install [SDKMan](http://sdkman.io/install.html)


## Atom
As suggested from [Stackoverflow](https://stackoverflow.com/questions/30006827/how-to-save-atom-editor-config-and-list-of-packages-installed), install frozen packages:
```bash
$ apm install --packages-file ~/.atom/apm_packages_bakup.txt
```

Back the installed ones up with:
```bash
$ apm list --installed --bare > ~/.atom/apm_packages_bakup.txt
```




# Table of Contents generation
The table of contents was generated using [markdown-toc](https://github.com/jonschlinkert/markdown-toc)
```bash
$ sudo npm install -g markdown-toc
$ # add toc marker to README.md
$ markdown-toc -i ~/.dotfiles/README.md
```

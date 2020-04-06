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
  * [rvm (optional)](#rvm-optional)
  * [Vim](#vim)
    + [Compile command-t](#compile-command-t)
    + [vim-instant-markdown](#vim-instant-markdown)
    + [MacVim](#macvim)
  * [Tmux](#tmux)
  * [Shell](#shell)
    + [ZSH](#zsh)
    + [Bash](#bash)
  * [Xcode](#xcode)
  * [Intellij/PyCharm/PhpStorm](#intellijpycharmphpstorm)
  * [Taskwarrior](#taskwarrior)
  * [Firefox](#firefox)
  * [Atom](#atom)
  * [Java Development](#java-development)
  * [Python Development](#python-development)
    + [pyenv](#pyenv)
    + [jedi-vim](#jedi-vim)
    + [rope](#rope)
    + [isort](#isort)
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
and after making some changes to the branch, star quashing to one commit
```bash
$ git comitt -m "SQUASHED passwords"
```


Untrack `~/.irssi/config` for local changes.

```bash
$ source ~/.shell_aliases
$ dotf_irssiconf_untrack
```


## Host specific configuration
Passwords and other secretes are censored. To find these and substitue them for the real thing, do

```bash
$ grep -nr GIT-CENSORED . | grep -v README.md | grep -v "/.git/"
```


Set `DESKTYPE` in `~/.shell_commons`, unless system is macos.


Default desktop is assumed to be macOS. Go through host-specific manual settings by searching for the corresponding tag.

```bash
$ grep -nr MACOS-CONFIG . 2>/dev/null | grep -v README.md
$ grep -nr LINUX-CONFIG . 2>/dev/null | grep -v README.md
$ grep -nr FREEBSD-CONFIG . 2>/dev/null | grep -v README.md
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

## rvm (optional)
Install latest [ruby version environment](https://rvm.io/rvm/install). 
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

### [vim-instant-markdown](https://github.com/suan/vim-instant-markdown)
```bash
$ sudo npm -g install instant-markdown-d
````


### MacVim
* Install [Inconsolata](https://github.com/google/fonts/tree/master/ofl/inconsolata) font which my [.gvimrc](.gvimrc) is set up with. `macos_install.sh` already installs it.

## Tmux

Install:

 * urlview(1)
 * [seebi/tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized)
 ```bash
 $ cd ~/src
 $ git clone git@github.com:seebi/tmux-colors-solarized.git
 ```
 * ~~`brew install reattach-to-user-namespace` if on OSX~~
 * --[tpm](https://github.com/tmux-plugins/tpm)--
```bash
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
````
Then reload tmux.conf

```
$ tmux source ~/.tmux.conf
```
and press `prefix-I` to install tpm plugins.


Update `~/.tmux.conf` to use xclip for linux and pbcopy/pbpaste for macOS and the default-command option.


## Shell

Install for both zsh and bash:
 * [seebi/dircolors-solarized](https://github.com/seebi/dircolors-solarized) (only for Linux systems)
 * [GNU source-highlight](https://www.gnu.org/software/src-highlite/source-highlight.html) for less(1). To make it work on macOS, run `source-highlight-settings(1)` and create a new data dir at the path `/usr/local/share/source-highlight`.


### ZSH
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

* [mollifier/cd-bookmark](https://github.com/mollifier/cd-bookmark)
```bash
$ ghq clone https://github.com/mollifier/cd-bookmark.git
$ cd ~/.dotfiles
$ s dot
$ cd ~/dl/
$ s dl
````

### Bash
* [huyng/bashmarks](https://github.com/huyng/bashmarks)
```bash
$ ghq-get https://github.com/huyng/bashmarks.git
$ make install
````


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


## Atom
As suggested from [Stackoverflow](https://stackoverflow.com/questions/30006827/how-to-save-atom-editor-config-and-list-of-packages-installed), install frozen packages:
```bash
$ apm install --packages-file ~/.atom/apm_packages_bakup.txt
```

Back the installed ones up with:
```bash
$ apm list --installed --bare > ~/.atom/apm_packages_bakup.txt
```


## Java Development
* Install [SDKMan](http://sdkman.io/install.html) to go between version of java and java tools.


## Python Development
### pyenv
Be more flexible with what python version to use with pyenv.
macOS: `$ brew install pyenv`

Remember that when using pyenv, normal virtualenv can't be used for python <3.3 projects. One should use [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) instead. See [this](https://www.freecodecamp.org/news/manage-multiple-python-versions-and-virtual-environments-venv-pyenv-pyvenv-a29fb00c296f/) article and [this](https://realpython.com/intro-to-pyenv/).
```bash
$ pyenv virtualenv 2.7.10 my-virtual-env-2.7.10
````


```bash
$ pyenv versions
$ pyenv install 3.x.y
$ pyenv global 3.x.y
$ python --version
$ which python
````



### jedi-vim
```bash
$ cd ~/.vim/bundle/jedi-vim/
$ git submodule update --init
````

### rope
```bash
$ pip3 install --user ropevim
$ cat >> ~/.zshrc
export PYTHONPATH="$PYTHONPATH:$HOME/Library/Python/3.5/lib/python/site-packages"
^D
````

### isort
```bash
$ pip3 install --user isort
````







# Table of Contents generation
The table of contents was generated using [markdown-toc](https://github.com/jonschlinkert/markdown-toc)
```bash
$ sudo npm install -g markdown-toc
$ # add toc marker to README.md
$ markdown-toc -i ~/.dotfiles/README.md
```

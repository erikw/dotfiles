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
  * [Tmux](#tmux)
  * [Shell](#shell)
    + [ZSH](#zsh)
    + [Bash](#bash)
  * [Firefox](#firefox)
- [Table of Contents generation](#table-of-contents-generation)

<!-- tocstop -->

# Highlights

 * Check out my Vim configurations -- they are pretty cool!
 * [bin/](bin/) -- many handy and time saving scripts.
   * [pdf_compress.sh](bin/pdf_compress.sh) -- compress file size of PDFs!

# Installation

## Set up Github credentials

### Generate a pair of new SSH keys
```bash
$ cd /tmp
$ curl -O https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/ssh-keygen.sh
$ chmod 744 ssh-keygen.sh
$ ./ssh-keygen.sh
```

Add a config for Github, but don't bother about the values. Instead after this open up `~/.ssh/config` and remove the newly added github section and replace it with

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

## Git email
Needs to be set for GitHub to [associate](https://docs.github.com/en/github/setting-up-and-managing-your-github-user-account/managing-email-preferences/setting-your-commit-email-address) commits.

Set up git user email address in `~/.config/git/config-local`:
```
[user]
	email = user@doman.tld
```


## Install DFM

```bash
$ git clone git@github.com:erikw/dotfiles.git ~/.dotfiles
$ cd !$
$ git remote add upstream git@github.com:justone/dotfiles.git
$ git submodule init
$ git submodule update
$ bin/dfm install
```

``

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
$ mkdir -p ~/src/github.com
$ cd !$
$ git clone git@github.com:altercation/solarized.git
````


## Tmux

Install:

 * urlview(1)
 * [seebi/tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized)
 ```bash
 $ cd ~/src/github.com
 $ git clone git@github.com:seebi/tmux-colors-solarized.git
 ```
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


## Firefox
Import minimal search-keyword bookmarks from [.bookmarks_minimal.html](.bookmarks_minimal.html) to Firefox.

## Global Gems
BUNDLE_GEMFILE=$XDG_CONFIG_HOME/ruby/Gemfile bundle install

## GLobal NPM packages
~/bin/npm-install-global.sh

# Table of Contents generation
The table of contents was generated using [markdown-toc](https://github.com/jonschlinkert/markdown-toc)
```bash
$ npm install -g markdown-toc
$ # add toc marker to README.md
$ markdown-toc -i ~/.dotfiles/README.md
```

<p align="center">
<img alt="log" width="100%" height="100%" src="img/logo.png" />
</p>
<p align="center"><i>Files that makes me feel at home!</i></p>

# Dotfiles
[![GitHub Stars](https://img.shields.io/github/stars/erikw/dotfiles?style=social)](#)
[![GitHub Forks](https://img.shields.io/github/forks/erikw/dotfiles?style=social)](#)
<br>
[![SLOC](https://img.shields.io/tokei/lines/github/erikw/dotfiles?logo=codefactor&logoColor=lightgrey)](#)
[![Number of programming languages used](https://img.shields.io/github/languages/count/erikw/dotfiles)](#)
[![Top programming languages used](https://img.shields.io/github/languages/top/erikw/dotfiles)](#)

Most of my personal dotfiles can be found in this branch. I use [dotbot](https://github.com/anishathalye/dotbot) to install and managed the dotfiles.

## Highlights
* [.config/](.config/) - I've spent quite some effort to make my dotfiles adhere to the [XDG](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) Base Directory Standard as much as possible, using and contributing to the [Arch wiki page](https://wiki.archlinux.org/title/XDG_Base_Directory). As far from all programs that I use support this natively, quite some custom configuration neeeded to be done. Grep for `XDG` in [.config/shell/commons](.config/shell/commons).
* Check out my Neovim configurations [.config/nvim/](.config/nvim)-- they are pretty cool!
* [bin/](bin/) -- many handy and time saving scripts.
  * [pdf_compress.sh](bin/pdf_compress.sh) -- compress file size of PDFs!

## Installation
### Bootstrapped
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/dotfiles_bootstrap.sh)"
```

### Manual
#### Git
##### Generate a pair of new SSH keys for GitHub
```shell
cd /tmp
curl -O https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/ssh-keygen.sh
curl -O https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/ssh-config-create.sh
chmod 744 ssh-keygen.sh ssh-config-create.sh
./ssh-keygen.sh
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

```shell
# Linux:
xclip ~/.ssh/identityfiles/github_id_rsa.pub
$ # or, macOS:
pbcopy <  ~/.ssh/identityfiles/github_id_rsa.pub
```

##### Git E-Mail
Set up git user email address in `~/.config/git/config-local`:
```
[user]
	email = user@doman.tld
```
##### Clone dotfiles repo and install
* Clone repo
```shell
git clone git@github.com:erikw/dotfiles.git ~/src/github.com/erikw/dotfiles
cd !$
./install.sh
```

### Post-install
Switch to a local branch for secret changes:
```shell
cd ~/.dotfiles
git checkout -b local
```

and after making some changes to the branch, squash to one commit
```shell
git commit -m "SQUASHED passwords"
```

### Host specific configuration
* Passwords and other secretes are censored. To find these and substitue them for the real thing, do:
	```shell
	grep -nr GIT-CENSORED . | grep -v README.md | grep -v "/.git/"
	```
* Set `DESKTYPE` in `$XDG_CONFIG_HOME/shell/commons`, unless system is macos.
* Default desktop is assumed to be macOS. Go through host-specific manual settings by searching for the corresponding tag.
	```shell
	grep -nr MACOS-CONFIG . 2>/dev/null | grep -v README.md
	grep -nr LINUX-CONFIG . 2>/dev/null | grep -v README.md
	grep -nr FREEBSD-CONFIG . 2>/dev/null | grep -v README.md
	```


### Firefox
See [.config/firefox/](.config/firefox/).

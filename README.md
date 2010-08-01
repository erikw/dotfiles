# Dotfiles

## Overview

This repo is a skeleton/template repo for tracking dotfiles.  It contains
a utility ([dfm](https://github.com/justone/dfm)) to help with managing and
updating your dotfiles.

## Using this repo

First, fork this repo.

Then, add your dotfiles:

    $ git clone git@github.com:username/dotfiles.git .dotfiles
    $ cd .dotfiles
    $  # edit files
    $  # edit files
    $ git push origin master

Finally, to install your dotfiles onto a new system:

    $ cd $HOME
    $ git clone git@github.com:username/dotfiles.git .dotfiles
    $ ./.dotfiles/bin/dfm install # creates symlinks to install files

## Full documentation

For more information, check out the [wiki](http://github.com/justone/dotfiles/wiki).

You can also run <tt>dfm --help</tt>.

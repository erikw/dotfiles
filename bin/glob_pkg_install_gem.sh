#!/usr/bin/env sh
# Install global Gems from a custom requirements file.
# Requremens: bundle

export BUNDLE_GEMFILE=${XDG_CONFIG_HOME:-$HOME/.config}/bundle/Gemfile
bundle install
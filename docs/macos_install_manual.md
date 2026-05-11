# macOS Manual Setup
## General System
### EurKey
Enable the keymap from System Preferences > Keyboard > Input Sources. Replace US with EurKey.

### Brother DCP-7070dw
- **Printer**
  - Install driver from https://support.brother.com/g/b/downloadtop.aspx?c=eu_ot&lang=en&prod=dcp7070dw_eu
  - System Preferences > Printers & Scanners > + > Add by Bonjour discovery on network
- **Scanner**: use the "Brother iPrint&Scan" app from App Store, as the ICA driver (Image Capture.app) is not working.
- If not already the case, make sure lpr uses the default printer:

```sh
lpstat -p -d
lpoptions -d Brother_DCP_7070DW
lpoptions -p Brother_DCP_7070DW  -o PageSize=A4 -o Printing=DuplexNoTumble -o Duplex/Two-Sided=true
```

Then set default options used for the GUI printing dialog.
Ref: https://support.pirateship.com/en/articles/2799085-mac-how-to-change-default-printer-settings

- Run `cupsctl WebInterface=yes`
- Go to http://localhost:631/printers/, log in with system user and password
- Select your printer > Dropdown: Set Default Options
  - Media Size: A4
  - Two-Sided Printing: Long-Edge Binding

### Clipy
#### General
- Max clipboard history size: 100

#### Menu
- Number of items to place inline: 25
- Number of items to place inside a folder: 75
- Number of characters in the menu: 50

#### Shortcuts
- Menu > Main: NOP
- Menu > History: Cmd+Shift+V
- Menu > Snippets: Cmd+Shift+B
- History > Clear history: Shift+Ctrl+Opt+Cmd+C

#### Snippets
Create snippets for some common items in `~/doc/tech/word_expansions.txt`.

#### App
- Check: Start at login
- Uncheck: Show in menu bar

### Sensiblesidebuttons / Sanesidebuttons
- Launch it one time to set right permissions needed.
- From menu bar icon: hide icon
- System Settings > General > Login items > add it manually

### Mail.app
GMailinator plug-in. The most maintained fork is https://github.com/wwwjfy/GMailinator, but using another fork's `install.sh` makes it easier: https://github.com/jasoncodes/GMailinator/blob/master/install.sh

Requires full XCode.app installed from App Store.

```sh
ghq-get git@github.com:jasoncodes/GMailinator.git
./install.sh
```

Then go to Mail.app > Preferences > General > Manage Plug-ins... > enable GMailinator.

### Ghostty
- System Settings > Privacy & Security:
  - Full Disk Access: enable, to avoid many different permission request popups later
  - Accessibility Features: enable, for global shortcuts to work


### Jettison
#### Options
- Check: Launch at start

##### Hotkeys
- Eject external disks: Ctrl+Opt+Cmd+E
- Eject disks and sleep: Ctrl+Opt+Cmd+S

### The Unarchiver
#### Archive Formats
Enable for most archives. Might have to change in Finder for it to be the default program for some files.

#### Extraction
- Uncheck "Reveal expanded items in Finder".


### Custom Fonts
- Open Font Book.app > File > Add Fonts > `~/media/fonts/`
  - Skip all fonts with warnings/errors

### Pixelmator Pro
#### General
- Appearance: Auto
- New Image contents: transparent

#### Extension
Select "Save to Pictures" instead of iCloud.


### dict.cc Dictionary Plugin
From https://www.dict.cc/?s=about%3Awordlist&l=e

To use it:

- Open Dictionary.app > Preferences > enable and move up the preference order of the "Deutsch-Englisch" dictionary.


---

## Automator Actions
### Screen Saver
1. Open Automator.
2. Create a new service (now named Quick Action).
3. Choose "Run AppleScript".
4. In the top of the window, set "Service receives selected" to "no input" and "in any application".
5. Paste the following AppleScript:

```applescript
on run {input, parameters}
    do shell script "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"
    return input
end run
```

6. Save with the name "start_screensaver".
7. Open System Preferences > Keyboard > Shortcuts > Services > General and assign this quick action the shortcut Ctrl+Cmd+L.

If "start_screensaver" did not show up, try logging in and out or restarting the computer.

### Appearance Toggle (Light/Dark Mode)
- Create an Automator.app Quick Action named "appearance_toggle".
- Use the built-in action "Change System Appearance" by dragging it in, and set "Change Appearance" to "Toggle Light/Dark". This seems faster when toggling than the custom script `~/bin/automator/appearance_toggle.command`.
- Bind to Service shortcut Ctrl+Opt+Cmd+T (shortcut used when this feature was first introduced in the OS).

### Microsoft To Do
- Create an Automator Quick Action named "ms_todo_start" with AppleScript with action "Launch Application".
- Bind to shortcut Ctrl+Cmd+Y.

### Cycle Audio Output Devices
Do this for all `~/bin/automator/SwitchAudioSource*.command`:

- Create an Automator Quick Action named "SwitchAudioSource_cycle" with AppleScript using the contents of `~/bin/automator/SwitchAudioSource_cycle.command`.
- Bind to shortcuts:
  - Built-in: Cmd+Opt+F11
  - USB Soundcard/headset: Cmd+Opt+F12
  - Cycle: Cmd+Opt+F13

### Control Center
> TODO: replace this with a native System Preferences shortcut when supported.

- Create an Automator Quick Action named "open_controlcenter" with AppleScript using the contents of `~/bin/automator/open_controlcenter.command`.
- Bind to shortcut Cmd+F10.
- For this to work: System Preferences > Security & Privacy > Privacy > Accessibility > allow System Preferences.app.

### Now Playing
> TODO: replace this with a native System Preferences shortcut when supported.

- Create an Automator Quick Action named "open_nowplaying" with AppleScript using the contents of `~/bin/automator/open_nowplaying.command`.
- Bind to shortcut Cmd+F9.
- For this to work: System Preferences > Security & Privacy > Privacy > Accessibility > allow System Preferences.app.

---

## Development
### General
#### Dash.app
##### General
- Show Dash and focus on search field: Cmd+Shift+D
- Uncheck "Show dock icon"
- Check "Show menu bar icon"
- Sync: set folder `~/dropbox/data/dash/` — own subdir so this can be shared with a work Dropbox account.

### C/C++
#### LSP Server
```sh
brew install ccls
```


### Java
#### LSP Server
No good one exists that is easily installable. See https://microsoft.github.io/language-server-protocol/implementors/servers/

`eclipse.jdt.ls` is clumsy — no brew formula. Only hack that is not working: https://github.com/edganiukov/homebrew

### Ruby
#### Rails
References:
- https://sergio-ildefonso.medium.com/install-ruby-and-rails-on-a-mac-7b8a1ccb5f4
- https://gorails.com/setup/osx/10.13-high-sierra

```sh
gem install rails
```

Dependencies:

```sh
brew install sqlite3      # macOS version is old
npm install -g yarn       # yarn - better than npm
```

> **Note:** for Node, get a version manager — NVM is slow and cumbersome; use ASDF instead. See the JavaScript section.

> **Note:** unset `CC=clang` if creating a new Rails app, as the `byebug` dependency fails with clang.

### Python
State of the art:
- Python version: pyenv, or better with asdf
- Project dependencies: poetry
- Global python tools: pipx



---

## DJing
### Djay Pro AI
#### General
- Slide Range ±: 8% — compromise of 6% or 10%. See https://www.reddit.com/r/Beatmatch/comments/c9012w/pitch_control_6_or_10_my_thoughts_and_asking_for/
  - Use +6% for learning, as the fader is very small
- Uncheck: Reset (EQ, effect, controls)
- Stop time: 0.0 seconds

#### Devices
- See `~/doc/music/device_setups.xlsx` DJ tab

#### Library
- Check: Hide unavailable tracks

#### Appearance
- Font size: 3/4
- Check: Show bar numbers
- Check: Show minute markers
- Check: Dim inactive deck

---

## Music Production
### Ableton Live
Download from https://www.ableton.com/en/account/

Set root path: `root=/Volumes/ext0/daw/`

#### Look and Feel
- Theme: Dark

#### Audio
Use CoreAudio driver and Scarlett 2i2 for input/output, according to the Focusrite Scarlett 2i2 3rd Gen User Guide (`~/doc/man/music/focusrite_scarlett-2i2-3rd_genuser-guide.pdf`) page 10, or https://getstarted.focusrite.com/en/scarlett/set-your-input-and-output-device

- Driver Type: Core Audio
- Audio Input Device: Scarlett 2i2 USB
- Audio Output Device: Scarlett 2i2 USB
- IO Sample Rate: 44100
- Default SR Conversion: High Quality
- Buffer Size: 512 samples
- Driver Error Compensation: 0.0

#### Link MIDI
Set up Ableton MIDI input/output according to the Novation Launchkey MK3 Manual (`~/doc/man/music/novation_launchkey_mk3_manual_v1.03.pdf`) page 12.

Control Surfaces — the first 2 rows should be:
- Control Surface: Launchkey MK3
- Input: Launchkey MK3 37 (LKM3 DAW Output)
- Output: Launchkey MK3 37 (LKM3 DAW Input)

Takeover mode: pickup

Control Surfaces configuration:
- Input Launchkey MK3 37 (LKM3 MIDI Output): Track=On, Sync=Off, Remote=On
- Input Launchkey_MK3 Input (Launchkey): Track=On, Sync=Off, Remote=On
- Output Launchkey MK3 37 (LKM3 MIDI Input): Track=On, Sync=On, Remote=On
- Output Launchkey_MK3 Output (Launchkey): Track=On, Sync=Off, Remote=On

#### Files and Folders
Adjust the default empty project using "Save current Set as Default" after:
- Keeping 1 MIDI track only with brown color (drums).
- Setting preview volume on master channel's mixer to -8dB (headphones are very loud by default).

#### Library
- Location of User Library: `$root/ableton/includes/user_library/`
- Installation Folder for Packs: `$root/ableton/includes/factory_packs/`

#### Plug-Ins
Use Custom Paths for personal install paths; keep manuals etc in `$root/plugins/installers/`. See https://help.ableton.com/hc/en-us/articles/209068929-Using-AU-and-VST-plug-ins-on-Mac

- Use VST2 Plug-In System Folder: true
- Use VST2 Plug-In Custom Folder: true
- VST2 Plug-In Custom Folder: `$root/plugins/VST/`
- Use VST3 Plug-In System Folder: true
- Use VST3 Plug-In Custom Folder: true
- VST3 Plug-In Custom Folder: `$root/plugins/VST3/`

#### Other
Add these directories to the Ableton browser:

```
$root/../music/samples/
$root/ableton/packs/
$root/ableton/templates/
$root/ableton/ableton_template_sets/
$root/ableton/max/
```







---
# Archived
### Amethyst
#### General
- Uncheck "Display layout when changing spaces".

#### Layouts
- Set the following layouts to be used: tall, fullscreen, floating.

#### Shortcuts
Disable shortcuts as they conflict with EurKey input (like capital ÄÅ):

- Focus screen 1 (opt+shift+w), as opt+w produces Ä.
- Select Tall layout (opt+shift+a), as opt+shift+a produces Å.

#### Floating
- Add Pixelmator Pro, as the mouse hover tooltips are treated as own windows.


### Scroll Reverser
#### Scrolling
- Check: Enable Scroll Reverser
- Scrolling devices:
  - Uncheck: Reverse Trackpad
  - Check: Reverse Mouse

### iTerm2
- Load settings from Preferences > General > Preferences tab > Load from custom folder or URL. Reference: https://stackoverflow.com/a/23356086/265508
- System Settings > Privacy & Security > Full Disk Access: enable, to avoid many different permission request popups later
  - System Preferences > Security & Privacy > Privacy > Full Disk Access > Add iTerm.app

#### General
##### Closing
- Make it easier to restart/poweroff by not confirming closing multiple windows — I always use tmux so it's not a problem.
  - Uncheck: Confirm closing multiple sessions.
  - Uncheck: Confirm "iTerm2 (#Q)"

##### Selection
- Check "Applications in terminal may access clipboard" so that you can e.g. copy from vim buffer to GUI clipboard.

##### Colors
- Check "use different colors for light and dark mode"
  - For Light Mode and Dark Mode, select Color Preset... with Solarized Light/Dark respectively.

##### Text
Set font to one of:

- Hack Nerd Font, Regular, 15pt
- DM Mono, Regular, 14pt
- Source Code Pro, Regular, 14pt
- Terminus, Medium, 16pt
- Any NerdFont when using `lsd(1)`, e.g.: Hack Nerd Font, Regular, 14pt

##### Terminal
- Notifications > Check "Silence Bell"
- Check "Unlimited Scrollback"

##### Keys
###### General
- Make Option key a Meta key, so e.g. tmux binding works on MBP internal keyboard.
  - Set "Left option key acts as" to "Esc+". NOTE: need karabiner-elements to get left alt to work on external PC keyboard.

###### Key Mappings
Create shortcuts to toggle between Solarized dark & light:

- Press the '+' button:
  - Shortcut: Opt+Cmd+S
  - Action: "Load Color Preset" > "Solarized Light"
- Press the '+' button:
  - Shortcut: Opt+Cmd+Shift+S
  - Action: "Load Color Preset" > "Solarized Dark"

### Dropbox
- Remove `~/Dropbox` symlink and create:
  ```sh
  ln -s /Users/erikw/Library/CloudStorage/Dropbox ~/dropbox
  ```
- Create symlinks from `~/Library/CloudStorage/Dropbox/*` to `~/`. Don't create from `~/dropbox` because when there's >1 level of indirection, the macOS Dock won't follow the symlinks in the Stacks (list) folder feature.

#### General
- Dropbox badge: Never show (integrates into MS Office for example)

### InstaRemind
Hotkey: Ctrl+Cmd+R (like Todoist's Ctrl+Cmd+A)

### Todoist
- Disable macOS spelling correction in search bar by right-clicking in the search bar > Spelling and Grammar > uncheck "Correct Spelling Automatically". Reference: https://osxdaily.com/2011/08/18/disable-spelling-auto-correct-safari-mac-os-x/
- Disable badge count on Dock icon: System Preferences > Notifications > Todoist > uncheck "Badge app icon"


## Development
### Ruby
#### asdf Version Manager
Build requirements for building all Ruby versions from https://github.com/asdf-vm/asdf-ruby:

```sh
asdf plugin-add ruby
brew install openssl@1.1 openssl@3 readline libyaml gmp rust
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"  # Also set in shell commons for future builds
```

> **Note:** might have to unset `$GEM_HOME` before installing with rbenv: https://github.com/asdf-vm/asdf-ruby/issues/206#issuecomment-860106503

Install latest Ruby:

```sh
asdf install ruby latest
asdf set -u ruby latest
```

### Python
#### asdf Version Manager
Build requirements from https://github.com/danhper/asdf-python:

```sh
asdf plugin-add python
brew install openssl readline sqlite3 xz zlib
asdf install python latest
asdf set -u python latest
```

Install Poetry:

```sh
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
poetry completions zsh > $XDG_CONFIG_HOME/zsh/funcs/_poetry
```

Then reload compinit.

### Go
#### asdf Version Manager
```sh
asdf plugin-add golang
asdf install golang latest
asdf set -u golang latest
```

Go binaries: for [erikw/tmux-powerline](https://github.com/erikw/tmux-powerline).


### JavaScript
#### asdf Version Manager
Build requirements from https://github.com/asdf-vm/asdf-nodejs/:

```sh
asdf plugin add nodejs
brew install gpg gawk
asdf install nodejs latest
asdf set -u nodejs latest
```

### Java
#### asdf Version Manager
```sh
asdf plugin-add java
```

Build requirements from https://github.com/halcyon/asdf-java:

```sh
brew install bash curl unzip jq
```

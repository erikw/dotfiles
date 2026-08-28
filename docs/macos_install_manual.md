# macOS Manual Setup
>
> [!NOTE]  
> Notes on config for builti-in app apps: see [macos_config.sh](../bin/macos_config.sh)

## General System

### Brother DCP-7070dw

* **Printer**
  * Install driver from <https://support.brother.com/g/b/downloadtop.aspx?c=eu_ot&lang=en&prod=dcp7070dw_eu>
  * System Preferences > Printers & Scanners > + > Add by Bonjour discovery on network
* **Scanner**: use the "Brother iPrint&Scan" app from App Store, as the ICA driver (Image Capture.app) is not working.
* If not already the case, make sure lpr uses the default printer:

```sh
lpstat -p -d
lpoptions -d Brother_DCP_7070DW
lpoptions -p Brother_DCP_7070DW  -o PageSize=A4 -o Printing=DuplexNoTumble -o Duplex/Two-Sided=true
```

Then set default options used for the GUI printing dialog.
Ref: <https://support.pirateship.com/en/articles/2799085-mac-how-to-change-default-printer-settings>

* Run `cupsctl WebInterface=yes`
* Go to <http://localhost:631/printers/>, log in with system user and password
* Select your printer > Dropdown: Set Default Options
  * Media Size: A4
  * Two-Sided Printing: Long-Edge Binding

### Sensiblesidebuttons / Sanesidebuttons

* Launch it one time to set right permissions needed.
* From menu bar icon: hide icon
* System Settings > General > Login items > add it manually

### Ghostty

* System Settings > Privacy & Security:
  * Full Disk Access: enable, to avoid many different permission request popups later
  * Accessibility Features: enable, for global shortcuts to work

### Jettison

#### Options

* Check: Launch at start

##### Hotkeys

* Eject external disks: Ctrl+Opt+Cmd+E
* Eject disks and sleep: Ctrl+Opt+Cmd+S

### Custom Fonts

* Open Font Book.app > File > Add Fonts > `~/media/fonts/`
  * Skip all fonts with warnings/errors

### Pixelmator Pro

#### General

* Appearance: Auto
* New Image contents: transparent

#### Extension

Select "Save to Pictures" instead of iCloud.

### dict.cc Dictionary Plugin

From <https://www.dict.cc/?s=about%3Awordlist&l=e>

To use it:

* Open Dictionary.app > Preferences > enable and move up the preference order of the "Deutsch-Englisch" dictionary.

---

## Shortcuts.app

Import files from ~/bin/shortcuts/

### Sleep

* Action: Sleep
* Keyboard shortcut: ctrl+opt+cmd+s

### Appearance Toggle (Light/Dark Mode)

* Action: Change appearance (set to toggle)
* Keyboard shortcut: ctrl+opt+cmd+t

## Automator Actions

### Control Center
>
> TODO: replace this with a native System Preferences shortcut when supported.

* Create an Automator Quick Action named "open_controlcenter" with AppleScript using the contents of `~/bin/automator/open_controlcenter.command`.
* Bind to shortcut Cmd+F10.
* For this to work: System Preferences > Security & Privacy > Privacy > Accessibility > allow System Preferences.app.

### Now Playing
>
> TODO: replace this with a native System Preferences shortcut when supported.

* Create an Automator Quick Action named "open_nowplaying" with AppleScript using the contents of `~/bin/automator/open_nowplaying.command`.
* Bind to shortcut Cmd+F9.
* For this to work: System Preferences > Security & Privacy > Privacy > Accessibility > allow System Preferences.app.

---

## Development

### General

#### Dash.app

##### General

* Show Dash and focus on search field: Cmd+Shift+D
* Uncheck "Show dock icon"
* Check "Show menu bar icon"
* Sync: set folder `~/dropbox/data/dash/` — own subdir so this can be shared with a work Dropbox account.

### C/C++

#### LSP Server

```sh
brew install ccls
```

### Java

#### LSP Server

No good one exists that is easily installable. See <https://microsoft.github.io/language-server-protocol/implementors/servers/>

`eclipse.jdt.ls` is clumsy — no brew formula. Only hack that is not working: <https://github.com/edganiukov/homebrew>

### Ruby

#### Rails

References:

* <https://sergio-ildefonso.medium.com/install-ruby-and-rails-on-a-mac-7b8a1ccb5f4>
* <https://gorails.com/setup/osx/10.13-high-sierra>

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

* Python version: pyenv, or better with asdf
* Project dependencies: poetry
* Global python tools: pipx

---

## DJing

### Djay Pro AI

#### General

* Slide Range ±: 8% — compromise of 6% or 10%. See <https://www.reddit.com/r/Beatmatch/comments/c9012w/pitch_control_6_or_10_my_thoughts_and_asking_for/>
  * Use +6% for learning, as the fader is very small
* Uncheck: Reset (EQ, effect, controls)
* Stop time: 0.0 seconds

#### Devices

* See `~/doc/music/device_setups.xlsx` DJ tab

#### Library

* Check: Hide unavailable tracks

#### Appearance

* Font size: 3/4
* Check: Show bar numbers
* Check: Show minute markers
* Check: Dim inactive deck

---

## Music Production

### Ableton Live

Download from <https://www.ableton.com/en/account/>

Set root path: `root=/Volumes/ext0/daw/`

#### Look and Feel

* Theme: Dark

#### Audio

Use CoreAudio driver and Scarlett 2i2 for input/output, according to the Focusrite Scarlett 2i2 3rd Gen User Guide (`~/doc/man/music/focusrite_scarlett-2i2-3rd_genuser-guide.pdf`) page 10, or <https://getstarted.focusrite.com/en/scarlett/set-your-input-and-output-device>

* Driver Type: Core Audio
* Audio Input Device: Scarlett 2i2 USB
* Audio Output Device: Scarlett 2i2 USB
* IO Sample Rate: 44100
* Default SR Conversion: High Quality
* Buffer Size: 512 samples
* Driver Error Compensation: 0.0

#### Link MIDI

Set up Ableton MIDI input/output according to the Novation Launchkey MK3 Manual (`~/doc/man/music/novation_launchkey_mk3_manual_v1.03.pdf`) page 12.

Control Surfaces — the first 2 rows should be:

* Control Surface: Launchkey MK3
* Input: Launchkey MK3 37 (LKM3 DAW Output)
* Output: Launchkey MK3 37 (LKM3 DAW Input)

Takeover mode: pickup

Control Surfaces configuration:

* Input Launchkey MK3 37 (LKM3 MIDI Output): Track=On, Sync=Off, Remote=On
* Input Launchkey_MK3 Input (Launchkey): Track=On, Sync=Off, Remote=On
* Output Launchkey MK3 37 (LKM3 MIDI Input): Track=On, Sync=On, Remote=On
* Output Launchkey_MK3 Output (Launchkey): Track=On, Sync=Off, Remote=On

#### Files and Folders

Adjust the default empty project using "Save current Set as Default" after:

* Keeping 1 MIDI track only with brown color (drums).
* Setting preview volume on master channel's mixer to -8dB (headphones are very loud by default).

#### Library

* Location of User Library: `$root/ableton/includes/user_library/`
* Installation Folder for Packs: `$root/ableton/includes/factory_packs/`

#### Plug-Ins

Use Custom Paths for personal install paths; keep manuals etc in `$root/plugins/installers/`. See <https://help.ableton.com/hc/en-us/articles/209068929-Using-AU-and-VST-plug-ins-on-Mac>

* Use VST2 Plug-In System Folder: true
* Use VST2 Plug-In Custom Folder: true
* VST2 Plug-In Custom Folder: `$root/plugins/VST/`
* Use VST3 Plug-In System Folder: true
* Use VST3 Plug-In Custom Folder: true
* VST3 Plug-In Custom Folder: `$root/plugins/VST3/`

#### Other

Add these directories to the Ableton browser:

```
$root/../music/samples/
$root/ableton/packs/
$root/ableton/templates/
$root/ableton/ableton_template_sets/
$root/ableton/max/
```

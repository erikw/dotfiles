# Firefox setup
Find the profile direcotry by going to Hamburger menu > Help > More troubleshooting information > Applications Basic header > Profile Folder

# Import files
* Import minimal bookmarks from https://github.com/erikw/dotfiles/blob/personal/.config/mozilla/bookmarks_minimal.html
* Copy `~/.config/firefox/user.js` to the default profile directory

## URL bar
* Hide things like Pocket by right clicking on it.
* To the right of the URL bar, keep: TreeStyleTabs, Downloads, <space>, Pushbullet, DarkReader, Lastpass

## Preferences (manual GUI)
### General
* Files & Applications: Set Download locations to `~/dl/`
### Search
* Remove unused search providers
* Set default search engine provider


## Dictionaries
* All: https://addons.mozilla.org/en-US/firefox/language-tools/
* English / United States - https://addons.mozilla.org/en-US/firefox/addon/us-english-dictionary/
* Swedish - https://addons.mozilla.org/en-US/firefox/addon/g%C3%B6rans-hemmasnickrade-ordli/
* German - https://addons.mozilla.org/en-US/firefox/addon/german-dictionary/

## Protocol handlers
Protocol handlers. Looks like the paths has to be absolute.
1. Add the *expose=false values in about:config
1. Click on a link with that protocol and firefox will ask what application to use. http://kb.mozillazine.org/Register_protocol
   .torrent is configured in ~/.mailcap
```
network.protocol-handler.expose.mailto;false
network.protocol-handler.expose.spotify;false
network.protocol-handler.expose.magnet;false
```

### Spotify URIs
Just registering the networkprotocol for spotify: urls is not enough, to get http://open.spotify.com/... links to work:
1) First visit a page like http://open.spotify.com/app/anydecentmusic, then click on the "I have Spotify" button.
2) Now try visiting another page like http://open.spotify.com/track/189gb58kHUdS5MdLBcz18f
-or-
Visit the web player and got settings and set URLs to be opened with the desltop app. https://play.spotify.com/

## Add-ons
For some addons, go to Manage and enable usage in private mode.

### Default
* https://addons.mozilla.org/en-US/firefox/addon/google-translator-webextension/
* https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/
* https://addons.mozilla.org/en-US/firefox/addon/lastpass-password-manager/
* https://addons.mozilla.org/en-US/firefox/addon/pushbullet/
* https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab/
* https://addons.mozilla.org/en-US/firefox/addon/darkreader/
* https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
* https://addons.mozilla.org/en-US/firefox/addon/tst-more-tree-commands/
* https://addons.mozilla.org/en-US/firefox/addon/check4change/

### Additional
* https://addons.mozilla.org/en-US/firefox/addon/tridactyl-vim/?src=external-github
* https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
* https://addons.mozilla.org/en-US/firefox/addon/want-my-rss/
* https://addons.mozilla.org/en-US/firefox/addon/4775/
* https://addons.mozilla.org/en-US/firefox/addon/dictionary-switcher/
* https://addons.mozilla.org/en-US/firefox/addon/emoji-cheatsheet/
* https://addons.mozilla.org/en-US/firefox/addon/epubreader/
* http://www.greasespot.net/
* http://livereload.com/
* https://addons.mozilla.org/en-US/firefox/addon/mobile-view-switcher/
* https://addons.mozilla.org/en-US/firefox/addon/722
* https://addons.mozilla.org/en-US/firefox/addon/redirect-cleaner/
* https://addons.mozilla.org/en-US/firefox/addon/521
* https://addons.mozilla.org/en-US/firefox/addon/skipscreen-incredible-rapidsha/
* https://addons.mozilla.org/en-US/firefox/addon/2108
* https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/
* http://appsweets.net/wasavi/

### Mobile
* I don't care about cookies
* uBlock origin
  * Add i-dont-care-about-cookies list: https://www.i-dont-care-about-cookies.eu/abp/
* Dark Reader



## Add-on configurations
### Tree Style Tab
Settings:
* Theme: Photon
* Close group without warning (not sure what this settings is called )

Now copy `~/.config/firefox/userChrome.css` to the default profile directory in a direcotry `chrome`. E.g. on macOS: ~/Library/ApplicationSupport/Firefox/Profiles/*.default/chrome/userChrome.css


### Lastpass
* Toolbar icon > Account Options > Extension Preferences > General > Check "log out when all browsers are closed."

### Dark Reader
* Set Toggle shortcut to Alt+d, as the default one clashes with Amethyst.
* Set to follow system theme by clicking the 3 vertical dots to the right of "off" > check "Use system color scheme"

### Google Translator
* Target language: Swedish
* Alternative language: English
* Minimum word length: 2 characters

### uBlock Origin
* Enable shortcut for zapper. Ref: https://github.com/gorhill/uBlock/wiki/Keyboard-shortcuts
  * Go to about:addons > gear wheel > Manage Extension Shortcuts > set Alt+z for Zapper.

// User prefereces, overrides local about:config changes
// Reference: http://kb.mozillazine.org/User.js_file
// Copy this file to path/to/firefox/profile/user.js
// Find changed values in profile/prefs.js or https://www.ghacks.net/2020/04/09/how-to-display-only-modified-preferences-on-aboutconfig/
// TODO consider using https://github.com/denis-g/firefox-user.js

// Startup: open prevoius windows and tabs
user_pref("browser.startup.page", 3);

// Theme: default syncing light/dark with OS.
user_pref("extensions.activeThemeID", "default-theme@mozilla.org");

// Don't automatically add .TLD when entering a search word in the URL bar.
user_pref("browser.fixup.alternate.enabled", false);

// Don't show Mozilla news on new tab pages.
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);

// Don't show sponsored links on Firefox start page.
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Number of rows of frequently visited pages to show on new tab page.
user_pref("browser.newtabpage.activity-stream.topSitesRows", 3);

// Open searches from search bar in a new tab.
user_pref("browser.search.openintab", true);

// Crashed to remember.
user_pref("browser.sessionstore.max_resumed_crashes", 2);

// Number of closed tabs to remember.
user_pref("browser.sessionstore.max_tabs_undo", 64);

// Don’t close window when closing the last tab.
user_pref("browser.tabs.closeWindowWithLastTab", false);

// So urlview (firefox -new-tab) can be used without losing focus.
user_pref("browser.tabs.loadDivertedInBackground", true);

// Don't suggest open tabs when typing in the URL bar.
user_pref("browser.urlbar.suggest.openpage", false);

// So vim-instant-markdown can close tab when closing the file.
user_pref("dom.allow_scripts_to_close_windows", true);

// Don't recommend addons on webpages.
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Enable spellcheck in both single and multiline textfields.
user_pref("layout.spellcheckDefault", 2);

// Don't load URLs from clipboard with mouse wheel click.
user_pref("middlemouse.contentLoadURL", false);

// Disable requests to show notifications, except the ones that are already accepted.
user_pref("permissions.default.desktop-notification", 2);

// Enable tracking query parameter stripping also in private mode. Ref: https://www.bleepingcomputer.com/news/security/new-firefox-privacy-feature-strips-urls-of-tracking-parameters/
user_pref("privacy.query_stripping.enabled.pbmode", true);

// Enable blocking of tracking parts of a website.
user_pref("privacy.trackingprotection.enabled", true);

// Firefox sync intervall in ms. Default is to sync every 600000ms = 600000 / (10^3 * 60) min = 10min
user_pref("services.sync.syncInterval", 300000);


// Needs to be set for Tree Style Tabs userChrome.css hack to hide native tab bar should work. https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#for-userchromecss
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);


// disable; 1:shift; 4:alt; 8:meta (command). Set access key to Alt to prevent sites, e.g. wikimedia sites, from stealing my shortcuts (like E on wiki*).
//user_pref("ui.key.contentAccess", 0						#);

// Warn before closing Browser, for when hitting cmd+q accidentally instead of of cmd+w
//user_pref("browser.sessionstore.warnOnQuit", true);

// Look up DNS through SOCKS proxy if that is used.
//user_pref("network.proxy.socks_remote_dns", true);

// Download location
// Disabled: can't expand evvar or tilde
//user_pref("browser.download.dir", "$HOME/erikw/dl4");

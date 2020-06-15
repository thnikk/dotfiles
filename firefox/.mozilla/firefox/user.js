// Chad override settings

// Enable custom userchrome
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Enable browser inspector
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.theme", "dark");

// Force acceleration to fix fullscreen performance
user_pref("layers.acceleration.force-enabled", true);
//user_pref("layers.gpu-process.force-enabled", true);

// Disable newtab page
user_pref("browser.newtabpage.enabled", false);
//user_pref("browser.startup.homepage", "about:blank");

// Don't warn about open tabs when closing the browser
user_pref("browser.tabs.warnOnClose", false);

// Enable auto-scroll
user_pref("general.autoScroll", true);

// Set theme to compact
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");

// Disable alt for menu
user_pref("ui.key.menuAccessKeyFocuses", false);

// New tabs should open in the background
user_pref("browser.tabs.loadInBackground", true);
// Links should open in the same tab by default
//user_pref("browser.link.open_newwindow", 1);

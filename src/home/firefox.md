# Firefox

```nix "home-config" +=
programs.firefox = {
  enable = true;
  package = pkgs.firefox-wayland;
  extensions = with nur.repos.rycee.firefox-addons; [
    <<<firefox-ext>>>
  ];
  profiles.default = {
    settings = {
      <<<firefox-settings>>>
    };
    userChrome = ''
      <<<firefox-css>>>
    '';
  };

};
```

Force Firefox to use wayland

```nix "home-env" +=
MOZ_ENABLE_WAYLAND = 1;
```

Set as default

```nix "home-env" +=
BROWSER = "firefox";
```

## Mime

```nix "xdg-mime" +=
"text/html" = "firefox.desktop";
"x-scheme-handler/http" = "firefox.desktop";
"x-scheme-handler/https" = "firefox.desktop";
"x-scheme-handler/ftp" = "firefox.desktop";
"x-scheme-handler/chrome" = "firefox.desktop";
"x-scheme-handler/about" = "firefox.desktop";
"x-scheme-handler/unknown" = "firefox.desktop";
"application/x-extension-htm" = "firefox.desktop";
"application/x-extension-html" = "firefox.desktop";
"application/x-extension-shtml" = "firefox.desktop";
"application/xhtml+xml" = "firefox.desktop";
"application/x-extension-xhtml" = "firefox.desktop";
"application/x-extension-xht" = "firefox.desktop";
```

## Settings

```nix "firefox-settings" +=
"browser.uidensity" = 1; # Compact mode
"browser.download.useDownloadDir" = false;
```

Developer tools to inspect Firefox UI

```nix "firefox-settings" +=
"devtools.debugger.remote-enabled" = true;
"devtools.chrome.enabled" = true;
```

### DuckDuckGo

The search engine must be chosen manually.

## Extensions

```nix "firefox-ext" +=
bitwarden
vim-vixen
videospeed
(buildFirefoxXpiAddon {
  pname = "proxydocile";
  version = "2.2";
  addonId = "proxydocile@unipd.it";
  url = "https://softwarecab.cab.unipd.it/proxydocile/proxydocile.xpi";
  sha256 = "4O4fB/1Mujn1x18UvUJcWDEGc+K+ejkFlFtiNbtYvmc=";
  meta = {};
})
(buildFirefoxXpiAddon {
  pname = "musescore-downloader";
  version = "0.26.0";
  addonId = "{69856097-6e10-42e9-acc7-0c063550c7b8}";
  url = "https://addons.mozilla.org/firefox/downloads/file/3818223/musescore_downloader-0.26.0-an+fx.xpi";
  sha256 = "LX0dcNlTIxqnRk+JozFUt4AZuu7oVShL/p3S21BajnY=";
  meta = {};
})
```

### Privacy

Block many trackers

```nix "firefox-ext" +=
ublock-origin
multi-account-containers
facebook-container
decentraleyes
i-dont-care-about-cookies
(buildFirefoxXpiAddon {
  pname = "behind-the-overlay-revival";
  version = "1.8.3";
  addonId = "{c0e1baea-b4cb-4b62-97f0-278392ff8c37}";
  url = "https://addons.mozilla.org/firefox/downloads/file/1749632/behind_the_overlay_revival-1.8.3-fx.xpi";
  sha256 = "lcmwPIfy0CyuNiXYWzqrKGsBZHyEdSgR+wvptJs/aiI=";
  meta = {};
})
```

## Appearance

```nix "firefox-settings" +=
"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
```

Transparent bar

```css "firefox-css" +=
#main-window {
  background: #f9f9fa95 !important;
}
.tab-background:is([selected], [multiselected]),
.browser-toolbar:not(.titlebar-color) {
  background-color: #f9f9fa65 !important;
}
```




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
{ "text/html" = "firefox.desktop"; }
(subtypes "x-scheme-handler" "firefox.desktop"
  [ "http" "https" "ftp" "chrome" "about" "unknown" ])
(subtypes "aplication" "firefox.desktop"
  (map (ext: "x-extension-" + ext)
    [ "htm" "html" "shtml" "xhtml" "xht" ]
  ++ [ "xhtml+xml" ]))
```

## Settings

```nix "firefox-settings" +=
"browser.download.useDownloadDir" = false;
```

Developer tools to inspect Firefox UI

```nix "firefox-settings" +=
"devtools.debugger.remote-enabled" = true;
"devtools.chrome.enabled" = true;
```

### Privacy

Enable HTTPS everywhere

```nix "firefox-settings" +=
"dom.security.https_only_mode" = true;
"dom.security.https_only_mode_ever_enabled" = true;
```

Block some trackers

```nix "firefox-settings" +=
"privacy.donottrackheader.enabled" = true;
"privacy.trackingprotection.enabled" = true;
"privacy.trackingprotection.socialtracking.enabled" = true;
"privacy.partition.network_state.ocsp_cache" = true;
```

Disable telemetry

```nix "firefox-settings" +=
"browser.newtabpage.activity-stream.feeds.telemetry" = false;
"browser.newtabpage.activity-stream.telemetry" = false;
"browser.ping-centre.telemetry" = false;
"toolkit.telemetry.archive.enabled" = false;
"toolkit.telemetry.bhrPing.enabled" = false;
"toolkit.telemetry.enabled" = false;
"toolkit.telemetry.firstShutdownPing.enabled" = false;
"toolkit.telemetry.hybridContent.enabled" = false;
"toolkit.telemetry.newProfilePing.enabled" = false;
"toolkit.telemetry.reportingpolicy.firstRun" = false;
"toolkit.telemetry.shutdownPingSender.enabled" = false;
"toolkit.telemetry.unified" = false;
"toolkit.telemetry.updatePing.enabled" = false;
```

Disable tracking ads in newtab

```nix "firefox-settings" +=
"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
"browser.newtabpage.activity-stream.discoverystream.sponsored-collections.enabled" = false;
"browser.newtabpage.activity-stream.showSponsored" = false;
```

#### DuckDuckGo

The search engine must be chosen manually.

### Pocket

Disable unused Pocket

```nix "firefox-settings" +=
"browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
"extensions.pocket.enabled" = false;
"extensions.pocket.api" = "";
"extensions.pocket.oAuthConsumerKey" = "";
"extensions.pocket.showHome" = false;
"extensions.pocket.site" = "";
```

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

Compact mode

```nix "firefox-settings" +=
"browser.uidensity" = 1;
```

Enable custom stylesheet

```nix "firefox-settings" +=
"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
```

Transparent bar

```css "firefox-css" +=
#main-window {
  background: #f9f9faa5 !important;
}
.tab-background:is([selected], [multiselected]),
.browser-toolbar:not(.titlebar-color) {
  background-color: #f9f9fa65 !important;
}
```




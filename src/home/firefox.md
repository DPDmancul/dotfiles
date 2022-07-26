# Firefox

```nix "home-config" +=
programs.firefox = {
  enable = true;
  package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    forceWayland = true;
    extraPolicies = {
      ExtensionSettings = let
        ext = name: {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        };
      in {
        <<<firefox-ext>>>
      };
      <<<firefox-policies>>>
    };
  };
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

Ask if to download (and where) or to open a file

```nix "firefox-settings" +=
"browser.download.useDownloadDir" = false;
"browser.download.always_ask_before_handling_new_types" = true;
```

Developer tools to inspect Firefox UI

```nix "firefox-settings" +=
"devtools.debugger.remote-enabled" = true;
"devtools.chrome.enabled" = true;
```

Disable password manager

```nix "firefox-policies" +=
PasswordManagerEnabled = false;
```

### Privacy

Enable HTTPS everywhere

```nix "firefox-settings" +=
"dom.security.https_only_mode" = true;
"dom.security.https_only_mode_ever_enabled" = true;
```

Block some trackers

```nix "firefox-policies" +=
EnableTrackingProtection = {
  Value = true;
  Locked = true;
  Cryptomining = true;
  Fingerprinting = true;
};
```

```nix "firefox-settings" +=
"privacy.donottrackheader.enabled" = true;
"privacy.trackingprotection.enabled" = true;
"privacy.trackingprotection.socialtracking.enabled" = true;
"privacy.partition.network_state.ocsp_cache" = true;
```

Disable telemetry

```nix "firefox-policies" +=
DisableTelemetry = true;
DisableFirefoxStudies = true;
```

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

Disable search suggestions

```nix "firefox-settings" +=
"browser.search.suggest.enabled" = false;
```

#### DuckDuckGo

The search engine must be chosen manually.

### Pocket

Disable unused Pocket

```nix "firefox-policies" +=
DisablePocket = true;
```

```nix "firefox-settings" +=
"browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
"extensions.pocket.enabled" = false;
"extensions.pocket.api" = "";
"extensions.pocket.oAuthConsumerKey" = "";
"extensions.pocket.showHome" = false;
"extensions.pocket.site" = "";
```

## Extensions

Manage all extensions via home-manager

```nix "firefox-ext" +=
"*" = {
  installation_mode = "blocked";
  blocked_install_message = "Extensions managed by home-manager.";
};
```

```nix "firefox-ext" +=
"it-IT@dictionaries.addons.mozilla.org" = ext "dizionario-italiano";
"{446900e4-71c2-419f-a6a7-df9c091e268b}" = ext "bitwarden-password-manager";
# "vim-vixen@i-beam.org" = ext "vim-vixen";
"{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = ext "videospeed";
"proxydocile@unipd.it"= {
  installation_mode = "force_installed";
  install_url = "https://softwarecab.cab.unipd.it/proxydocile/proxydocile.xpi";
};
"{69856097-6e10-42e9-acc7-0c063550c7b8}" = ext "musescore-downloader";
```

### Privacy

Block many trackers

```nix "firefox-ext" +=
"uBlock0@raymondhill.net" = ext "ublock-origin";
"@testpilot-containers" = ext "multi-account-containers";
"@contain-facebook" = ext "facebook-container";
"jid1-BoFifL9Vbdl2zQ@jetpack" = ext "decentraleyes";
"jid1-KKzOGWgsW3Ao4Q@jetpack" = ext "i-dont-care-about-cookies";
"{c0e1baea-b4cb-4b62-97f0-278392ff8c37}" = ext "behind-the-overlay-revival";
```

<!--
Block scripts

```nix "firefox-ext" +=
# "{73a6fe31-595d-460b-a920-fcc0f8843232}" = ext "noscript";
```
-->

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




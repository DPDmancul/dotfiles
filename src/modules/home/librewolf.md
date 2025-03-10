# LibreWolf

<!-- TODO: better organization -->

```nix modules/home/librewolf.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./xdg.nix
  ];

  programs.librewolf = {
    enable = true;
    policies = {
      # TODO: migrate to https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions
      ExtensionSettings = let
        ext = name: {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        };
      in {
        <<<modules/home/librewolf-ext>>>
      };
      <<<modules/home/librewolf-policies>>>
    };
    profiles.default = {
      settings = {
        <<<modules/home/librewolf-settings>>>
      };
      userChrome = ''
        <<<modules/home/librewolf-css>>>
      '';
    };
  };
  <<<modules/home/librewolf>>>
}
```

## Mime

```nix "modules/home/librewolf" +=
appDefaultForMimes."librewolf.desktop" = {
  text = "html";
  x-scheme-handler = [ "http" "https" "ftp" "chrome" "about" "unknown" ];
  application = map (ext: "x-extension-" + ext) [ "htm" "html" "shtml" "xhtml" "xht" ]
    ++ [ "xhtml+xml" ];
};
```

## Settings

Ask if to download (and where) or to open a file

```nix "modules/home/librewolf-settings" +=
"browser.download.useDownloadDir" = false;
"browser.download.dir" = "${config.xdg.userDirs.download}/LibreWolf";
"browser.download.always_ask_before_handling_new_types" = true;
```

Enable Firefox Sync

```nix "modules/home/librewolf-settings" +=
"identity.fxaccounts.enabled" = true;
"services.sync.engine.addons" = false;
"services.sync.engine.addresses" = false;
"services.sync.engine.creditcards" = false;
"services.sync.engine.passwords" = false;
"services.sync.engine.prefs" = false;
"services.sync.engine.bookmarks" = true;
"services.sync.engine.history" = true;
"services.sync.engine.tabs" = true;
```

Preserve data at shutdown

```nix "modules/home/librewolf-settings" +=
"privacy.clearOnShutdown.history" = false;
"privacy.clearOnShutdown.cookies" = false;
"privacy.clearOnShutdown_v2.cache" = false;
"privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
```

Enable hardware video acceleration

```nix "modules/home/librewolf-settings" +=
"media.ffmpeg.vaapi.enabled" = true;
```

Enable WebGL and DRM

```nix "modules/home/librewolf-settings" +=
"webgl.disabled" = false;
"media.eme.enabled" = true;
```

Developer tools to inspect Firefox UI

```nix "modules/home/librewolf-settings" +=
"devtools.debugger.remote-enabled" = true;
"devtools.chrome.enabled" = true;
```

Clean new tab page

```nix "modules/home/librewolf-settings" +=
"browser.newtabpage.activity-stream.feeds.topsites" = false;
```

Disable translations for some languages

```nix "modules/home/librewolf-settings" +=
"browser.translations.neverTranslateLanguages" = "it";
```

## Extensions

Manage all extensions via home-manager

```nix "modules/home/librewolf-ext" +=
"*" = {
  installation_mode = "blocked";
  blocked_install_message = "Extensions managed by home-manager.";
};
```

```nix "modules/home/librewolf-ext" +=
"it-IT@dictionaries.addons.mozilla.org" = ext "dizionario-italiano";
"{446900e4-71c2-419f-a6a7-df9c091e268b}" = ext "bitwarden-password-manager";
"{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = ext "videospeed";
"proxydocile@unipd.it" = {
  installation_mode = "force_installed";
  install_url = "https://softwarecab.cab.unipd.it/proxydocile/proxydocile.xpi";
};
```

### Privacy

Block many trackers

```nix "modules/home/librewolf-ext" +=
"@testpilot-containers" = ext "multi-account-containers";
"@contain-facebook" = ext "facebook-container";
"{b86e4813-687a-43e6-ab65-0bde4ab75758}" = ext "localcdn-fork-of-decentraleyes";
"{c0e1baea-b4cb-4b62-97f0-278392ff8c37}" = ext "behind-the-overlay-revival";
```

#### uBlock Origin

```nix "modules/home/librewolf-ext" +=
"uBlock0@raymondhill.net" = ext "ublock-origin";
```

Settings inspired from <https://codeberg.org/Magnesium1062/ublock-origin-settings>

```nix "modules/home/librewolf-policies" +=
"3rdparty".Extensions."uBlock0@raymondhill.net" = {
  userSettings = [
    [ "cloudStorageEnabled" "true" ]
    [ "prefetchingDisabled" "true"]
    [ "hyperlinkAuditingDisabled" "true" ]
    # TODO block CSP reports
    [ "cnameUncloakEnabled" "true" ]
    [ "autoUpdate" "true" ]
    [ "suspendUntilListsAreLoaded" "true" ]
    [ "parseAllABPHideFilters" "true" ] # Parse and enforce cosmetic filters
    [ "ignoreGenericCosmeticFilters" "false" ]
  ];
  toOverwrite = {
    filterLists = [
      "user-filters"
      "ITA-0"

      # Built-in
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-abuse"
      "ublock-quick-fixes"
      "ublock-unbreak"
      "ublock-badlists"

      # Ads
      "easylist"
      "adguard-generic"
      "adguard-mobile"

      # Privacy
      "easyprivacy"
      "adguard-spyware"
      "adguard-spyware-url"
      "block-lan"
      "https://divested.dev/blocklists/Fingerprinting.ubl"
      # "https://raw.githubusercontent.com/yokoffing/filterlists/main/block_third_party_fonts.txt"

      # Malware protection, security
      "urlhaus-1"
      "curben-phishing"
      "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/ips/tif.txt"
      "https://gist.githubusercontent.com/BBcan177/bf29d47ea04391cb3eb0/raw/7290e0681bcd07415420b5c80a253652fd13f840/MS-1"

      # Multipurpose
      "plowe-0"
      "dpollock-0"

      # Cookie notices (replaces istilldontcareaboutcookies)
      "fanboy-cookiemonster"
      "ublock-cookies-easylist"
      "adguard-cookies"
      "ublock-cookies-adguard"

      # Social widgets
      "fanboy-social"
      "adguard-social"
      "fanboy-thirdparty_social"

      # Annoyances
      "easylist-chat"
      "easylist-newsletters"
      "easylist-notifications"
      "easylist-annoyances"
      "adguard-mobile-app-banners"
      "adguard-other-annoyances"
      "adguard-popup-overlays"
      "adguard-widgets"
      "ublock-annoyances"

      # URL Shortener tools (replaces clearurls)
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
    ];
    filters = [
      "musescore.com##._sQKq"

      # IDN Homograph attacks
      "xn--*"
      "xn--*$doc,popup,frame"

      # Google Doubleclick & Analytics
      "||doubleclick.net^$important"
      "||google-analytics.com^$important"

      # Social media tracking
      "||facebook.com^$important,third-party"
      "||facebook.net^$important,third-party"
      "||linkedin.com^$important,third-party"
      "||instagram.com^$important,third-party"
      "||tiktok.com^$important,third-party"
      "||twitter.com^$third-party"
      "||x.com^$third-party"

      # 3rd party sign-in
      "||accounts.google.com^$third-party"
      "||appleid.apple.com^$third-party"
      "||appleid.cdn-apple.com^$third-party"
      "@@||accounts.google.com^$domain=youtube.com|chromium.org|gstatic.com|googleusercontent.com"
      "@@||appleid.apple.com^$domain=appleid.cdn-apple.com"
      "@@||appleid.cdn-apple.com^$domain=appleid.apple.com"
    ];
  };
};
```

## Appearance

Compact mode

```nix "modules/home/librewolf-settings" +=
"browser.uidensity" = 1;
"browser.tabs.inTitlebar" = 0;
```

Enable custom stylesheet

```nix "modules/home/librewolf-settings" +=
"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
```

Transparent bar

```css "modules/home/librewolf-css" +=
@media (prefers-color-scheme: light) {
  #main-window {
    background: #f9f9faa5 !important;
  }
  #navigator-toolbox {
    background-color: transparent !important;
  }
  .tab-background:is([selected], [multiselected]),
  .browser-toolbar:not(.titlebar-color) {
    background-color: #f9f9fa65 !important;
  }
}
```

Disable annoying sharing indicator

```css "modules/home/librewolf-css" +=
#webrtcIndicator {
  display: none;
}
```

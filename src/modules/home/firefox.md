# Firefox

<!-- TODO: better organization -->

```nix modules/home/firefox.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./xdg.nix
  ];

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    policies = {
      # TODO: migrate to https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions
      ExtensionSettings = let
        ext = name: {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        };
      in {
        <<<modules/home/firefox-ext>>>
      };
      <<<modules/home/firefox-policies>>>
    };
    profiles.default = {
      settings = {
        <<<modules/home/firefox-settings>>>
      };
      userChrome = ''
        <<<modules/home/firefox-css>>>
      '';
      <<<modules/home/firefox-profile>>>
    };
  };
  <<<modules/home/firefox>>>
}
```

## Mime

```nix "modules/home/firefox" +=
appDefaultForMimes."firefox.desktop" = {
  text = "html";
  x-scheme-handler = [ "http" "https" "ftp" "chrome" "about" "unknown" ];
  application = map (ext: "x-extension-" + ext) [ "htm" "html" "shtml" "xhtml" "xht" ]
    ++ [ "xhtml+xml" ];
};
```

## Touchpad gestures

Enable touchpad gestures on X11

```nix "modules/home/firefox" +=
home.sessionVariables.MOZ_USE_XINPUT2 = "1";
```

## Settings

Ask if to download (and where) or to open a file

```nix "modules/home/firefox-settings" +=
"browser.download.useDownloadDir" = false;
"browser.download.dir" = "${config.xdg.userDirs.download}/Firefox";
"browser.download.always_ask_before_handling_new_types" = true;
```

Firefox Sync

```nix "modules/home/firefox-settings" +=
"services.sync.engine.addons" = false;
"services.sync.engine.addresses" = false;
"services.sync.engine.creditcards" = false;
"services.sync.engine.passwords" = false;
"services.sync.engine.prefs" = false;
"services.sync.engine.bookmarks" = true;
"services.sync.engine.history" = true;
"services.sync.engine.tabs" = true;
```

Developer tools to inspect Firefox UI

```nix "modules/home/firefox-settings" +=
"devtools.debugger.remote-enabled" = true;
"devtools.chrome.enabled" = true;
```

Disable password manager

```nix "modules/home/firefox-policies" +=
PasswordManagerEnabled = false;
```

Enable hardware video acceleration

```nix "modules/home/firefox-settings" +=
"media.ffmpeg.vaapi.enabled" = true;
```

Disable translations for some languages

```nix "modules/home/firefox-settings" +=
"browser.translations.neverTranslateLanguages" = "it";
```

### Additional search engines

```nix "modules/home/firefox-profile" +=
search.engines = {
  nix-packages = {
    name = "Nix Packages";
    urls = [{
      template = "https://search.nixos.org/packages";
      params = [
        { name = "query"; value = "{searchTerms}"; }
      ];
    }];
    definedAliases = [ "@np" ];
  };

  nixos-options = {
    name = "NixOs Options";
    urls = [{
      template = "https://search.nixos.org/options";
      params = [
        { name = "query"; value = "{searchTerms}"; }
      ];
    }];
    definedAliases = [ "@no" ];
  };

  nixos-wiki = {
    name = "NixOS Wiki";
    urls = [{ 
      template = "https://wiki.nixos.org/w/index.php";
      params = [
        { name = "search"; value = "{searchTerms}"; }
      ];
    }];
    definedAliases = [ "@nw" ];
  };
};
```

### Privacy

Enable HTTPS everywhere

```nix "modules/home/firefox-settings" +=
"dom.security.https_only_mode" = true;
"dom.security.https_only_mode_ever_enabled" = true;
```

Block some trackers

```nix "modules/home/firefox-policies" +=
EnableTrackingProtection = {
  Value = true;
  Locked = true;
  Cryptomining = true;
  Fingerprinting = true;
};
```

```nix "modules/home/firefox-settings" +=
"privacy.donottrackheader.enabled" = true;
"privacy.trackingprotection.enabled" = true;
"privacy.trackingprotection.socialtracking.enabled" = true;
"privacy.partition.network_state.ocsp_cache" = true;
```

Disable telemetry

```nix "modules/home/firefox-policies" +=
DisableTelemetry = true;
DisableFirefoxStudies = true;
```

```nix "modules/home/firefox-settings" +=
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

```nix "modules/home/firefox-settings" +=
"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
"browser.newtabpage.activity-stream.discoverystream.sponsored-collections.enabled" = false;
"browser.newtabpage.activity-stream.showSponsored" = false;
```

Disable search suggestions

```nix "modules/home/firefox-settings" +=
"browser.search.suggest.enabled" = false;
```

Use DuckDuckGo as search engine

```nix "modules/home/firefox-profile" +=
search.default = "ddg";
search.privateDefault = "ddg";
```

### Pocket

Disable unused Pocket

```nix "modules/home/firefox-policies" +=
DisablePocket = true;
```

```nix "modules/home/firefox-settings" +=
"browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
"extensions.pocket.enabled" = false;
"extensions.pocket.api" = "";
"extensions.pocket.oAuthConsumerKey" = "";
"extensions.pocket.showHome" = false;
"extensions.pocket.site" = "";
```

## Extensions

Manage all extensions via home-manager

```nix "modules/home/firefox-ext" +=
"*" = {
  installation_mode = "blocked";
  blocked_install_message = "Extensions managed by home-manager.";
};
```

```nix "modules/home/firefox-ext" +=
"it-IT@dictionaries.addons.mozilla.org" = ext "dizionario-italiano";
"{446900e4-71c2-419f-a6a7-df9c091e268b}" = ext "bitwarden-password-manager";
"{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = ext "videospeed";
```

### Privacy

Block many trackers

```nix "modules/home/firefox-ext" +=
"@testpilot-containers" = ext "multi-account-containers";
"@contain-facebook" = ext "facebook-container";
"{b86e4813-687a-43e6-ab65-0bde4ab75758}" = ext "localcdn-fork-of-decentraleyes";
"{c0e1baea-b4cb-4b62-97f0-278392ff8c37}" = ext "behind-the-overlay-revival";
```

<!--
Block scripts

```nix "modules/home/firefox-ext" +=
# "{73a6fe31-595d-460b-a920-fcc0f8843232}" = ext "noscript";
```
-->

#### uBlock Origin

```nix "modules/home/firefox-ext" +=
"uBlock0@raymondhill.net" = ext "ublock-origin";
```

Settings inspired from <https://codeberg.org/Magnesium1062/ublock-origin-settings>

```nix "modules/home/firefox-policies" +=
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

```nix "modules/home/firefox-settings" +=
"browser.uidensity" = 1;
"browser.tabs.inTitlebar" = 0;
```

Enable custom stylesheet

```nix "modules/home/firefox-settings" +=
"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
```

Transparent bar

```css "modules/home/firefox-css" +=
@media (prefers-color-scheme: light) {
  #main-window {
    background: #f9f9faa5 !important;
  }
  body, #navigator-toolbox {
    background-color: transparent !important;
  }
  .tab-background:is([selected], [multiselected]),
  .browser-toolbar:not(.titlebar-color) {
    background-color: #f9f9fa65 !important;
  }
}
```

Disable annoying sharing indicator

```css "modules/home/firefox-css" +=
#webrtcIndicator {
  display: none;
}
```

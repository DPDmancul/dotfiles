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
    policies = {
      ExtensionSettings = let
        ext = name: {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        };
      in {
        <<<modules/home/fiefox-ext>>>
      };
      <<<modules/home/fiefox-policies>>>
    };
    profiles.default = {
      settings = {
        <<<modules/home/fiefox-settings>>>
      };
      userChrome = ''
        <<<modules/home/fiefox-css>>>
      '';
      <<<modules/home/fiefox-profile>>>
    };
  };
  <<<modules/home/fiefox>>>
}
```

## Mime

```nix "modules/home/fiefox" +=
appDefaultForMimes."firefox.desktop" = {
  text = "html";
  x-scheme-handler = [ "http" "https" "ftp" "chrome" "about" "unknown" ];
  application = map (ext: "x-extension-" + ext) [ "htm" "html" "shtml" "xhtml" "xht" ]
    ++ [ "xhtml+xml" ];
};
```

## Settings

Ask if to download (and where) or to open a file

```nix "modules/home/fiefox-settings" +=
"browser.download.useDownloadDir" = false;
"browser.download.dir" = "${config.xdg.userDirs.download}/Firefox";
"browser.download.always_ask_before_handling_new_types" = true;
```

Developer tools to inspect Firefox UI

```nix "modules/home/fiefox-settings" +=
"devtools.debugger.remote-enabled" = true;
"devtools.chrome.enabled" = true;
```

Disable password manager

```nix "modules/home/fiefox-policies" +=
PasswordManagerEnabled = false;
```

Enable hardware video acceleration

```nix "modules/home/fiefox-settings" +=
"media.ffmpeg.vaapi.enabled" = true;
```

### Privacy

Enable HTTPS everywhere

```nix "modules/home/fiefox-settings" +=
"dom.security.https_only_mode" = true;
"dom.security.https_only_mode_ever_enabled" = true;
```

Block some trackers

```nix "modules/home/fiefox-policies" +=
EnableTrackingProtection = {
  Value = true;
  Locked = true;
  Cryptomining = true;
  Fingerprinting = true;
};
```

```nix "modules/home/fiefox-settings" +=
"privacy.donottrackheader.enabled" = true;
"privacy.trackingprotection.enabled" = true;
"privacy.trackingprotection.socialtracking.enabled" = true;
"privacy.partition.network_state.ocsp_cache" = true;
```

Disable telemetry

```nix "modules/home/fiefox-policies" +=
DisableTelemetry = true;
DisableFirefoxStudies = true;
```

```nix "modules/home/fiefox-settings" +=
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

```nix "modules/home/fiefox-settings" +=
"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
"browser.newtabpage.activity-stream.discoverystream.sponsored-collections.enabled" = false;
"browser.newtabpage.activity-stream.showSponsored" = false;
```

Disable search suggestions

```nix "modules/home/fiefox-settings" +=
"browser.search.suggest.enabled" = false;
```

Use DuckDuckGo as search engine

```nix "modules/home/fiefox-profile" +=
search.default = "DuckDuckGo";
search.privateDefault = "DuckDuckGo";
```

### Pocket

Disable unused Pocket

```nix "modules/home/fiefox-policies" +=
DisablePocket = true;
```

```nix "modules/home/fiefox-settings" +=
"browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
"extensions.pocket.enabled" = false;
"extensions.pocket.api" = "";
"extensions.pocket.oAuthConsumerKey" = "";
"extensions.pocket.showHome" = false;
"extensions.pocket.site" = "";
```

## Extensions

Manage all extensions via home-manager

```nix "modules/home/fiefox-ext" +=
"*" = {
  installation_mode = "blocked";
  blocked_install_message = "Extensions managed by home-manager.";
};
```

```nix "modules/home/fiefox-ext" +=
"it-IT@dictionaries.addons.mozilla.org" = ext "dizionario-italiano";
"{446900e4-71c2-419f-a6a7-df9c091e268b}" = ext "bitwarden-password-manager";
# "vim-vixen@i-beam.org" = ext "vim-vixen";
"{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = ext "videospeed";
# "arklove@qq.com" = ext "git-master";
"proxydocile@unipd.it"= {
  installation_mode = "force_installed";
  install_url = "https://softwarecab.cab.unipd.it/proxydocile/proxydocile.xpi";
};
```

### Privacy

Block many trackers

```nix "modules/home/fiefox-ext" +=
"@testpilot-containers" = ext "multi-account-containers";
"@contain-facebook" = ext "facebook-container";
"jid1-BoFifL9Vbdl2zQ@jetpack" = ext "decentraleyes";
"{c0e1baea-b4cb-4b62-97f0-278392ff8c37}" = ext "behind-the-overlay-revival";
```

<!--
Block scripts

```nix "modules/home/fiefox-ext" +=
# "{73a6fe31-595d-460b-a920-fcc0f8843232}" = ext "noscript";
```
-->

#### uBlock Origin

```nix "modules/home/fiefox-ext" +=
"uBlock0@raymondhill.net" = ext "ublock-origin";
```

Settings inspired from <https://codeberg.org/Magnesium1062/ublock-origin-settings>

```nix "modules/home/fiefox-policies" +=
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
      "https://raw.githubusercontent.com/yokoffing/filterlists/main/block_third_party_fonts.txt"

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

      # DNS content blocking
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Dandelion%20Sprout's%20Anti-Malware%20List.txt"
      "https://divested.dev/hosts-domains-wildcards"
      "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/hoster.txt"
      "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/spam-tlds-ublock.txt"
      "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/pro.plus.txt"
      "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/tif.txt"
      "https://raw.githubusercontent.com/xRuffKez/NRD/main/nrd-14day_adblock.txt"
      "https://big.oisd.nl"
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
      "||gravatar.com^$important,third-party"

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

```nix "modules/home/fiefox-settings" +=
"browser.uidensity" = 1;
```

Enable custom stylesheet

```nix "modules/home/fiefox-settings" +=
"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
```

Transparent bar

```css "modules/home/fiefox-css" +=
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

```css "modules/home/fiefox-css" +=
#webrtcIndicator {
  display: none;
}
```

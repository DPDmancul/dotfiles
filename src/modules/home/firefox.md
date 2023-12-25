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
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
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
    };
    profiles.default = {
      settings = {
        <<<modules/home/fiefox-settings>>>
      };
      userChrome = ''
        <<<modules/home/fiefox-css>>>
      '';
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

#### DuckDuckGo

The search engine must be chosen manually.

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
"keepassxc-browser@keepassxc.org" = ext "keepassxc-browser";
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
"uBlock0@raymondhill.net" = ext "ublock-origin";
"@testpilot-containers" = ext "multi-account-containers";
"@contain-facebook" = ext "facebook-container";
"jid1-BoFifL9Vbdl2zQ@jetpack" = ext "decentraleyes";
"jid1-KKzOGWgsW3Ao4Q@jetpack" = ext "i-dont-care-about-cookies";
"{c0e1baea-b4cb-4b62-97f0-278392ff8c37}" = ext "behind-the-overlay-revival";
"{74145f27-f039-47ce-a470-a662b129930a}" = ext "clearurls";
```

<!--
Block scripts

```nix "modules/home/fiefox-ext" +=
# "{73a6fe31-595d-460b-a920-fcc0f8843232}" = ext "noscript";
```
-->

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

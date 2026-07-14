# Firefox

```nix PereWork/home/firefox.nix
{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        <<<PereWork/home/firefox-settings>>>
      };
      <<<PereWork/home/firefox-profile>>>
    };
  };
}
```

## Settings

Restore previous session on startup

```nix "PereWork/home/firefox-settings" +=
"browser.startup.page" = 3;
```

### Additional search engines

```nix "PereWork/home/firefox-profile" +=
search.engines = {
  redmine-issues = {
    name = "Redmine issues";
    urls = [{ template = "https://pm.mvlabs.it/issues/{searchTerms}"; }];
    definedAliases = [ "@pm" ];
  };
};
```


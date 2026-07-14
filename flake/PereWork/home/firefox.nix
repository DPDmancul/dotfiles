{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        "browser.startup.page" = 3;
      };
      search.engines = {
        redmine-issues = {
          name = "Redmine issues";
          urls = [{ template = "https://pm.mvlabs.it/issues/{searchTerms}"; }];
          definedAliases = [ "@pm" ];
        };
      };
    };
  };
}

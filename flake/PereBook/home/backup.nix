{ config, pkgs, lib, ... }:
{
  programs.borgmatic.enable = true;

  programs.borgmatic.backups.home = let
    mntPoint = "/run/media/${config.home.username}/refresh";
  in
  {
    location = {
      sourceDirectories = [ config.home.homeDirectory ];
      repositories = [ "${mntPoint}/home" ];
      excludeHomeManagerSymlinks = true;
      extraConfig = {
        exclude_caches = true;
        exclude_patterns = [
          "/home/*/.cache"
          "/home/*/.local/share/Trash"
          "*/.vim*.tmp"
          "*/.npm"
          "*/node_modules"
          "${config.home.homeDirectory}/datos/.Trash-1000"
          "${config.home.homeDirectory}/datos/Torrents"
          "${config.home.homeDirectory}/datos/Scrivania/Videos"
        ];
        progress = true;
        statistics = true;
        verbosity = 1;
      };
    };
    hooks.extraConfig.commands = [
      # do not execute if destination is unmounted
      {
        before = "repository";
        run = [ "findmnt ${mntPoint} > /dev/null || exit 75" ];
      }
    ];
    retention = {
      keepDaily = 7;
      keepWeekly = 4;
      keepMonthly = 6;
      keepYearly = 1;
    };
    storage.extraConfig = {
      compression = "zstd";
    };
  };
}

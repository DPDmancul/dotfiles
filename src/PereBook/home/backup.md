# Borg backup

Configure backup with borgmatic

```nix PereBook/home/backup.nix
{ config, pkgs, lib, ... }:
{
  programs.borgmatic.enable = true;

  <<<PereBook/home/backup>>>
}
```

## Home backup

**Important**  
Be sure there is always some free space on destination (see [doc](https://borgbackup.readthedocs.io/en/stable/quickstart.html#important-note-about-free-space)).  
If you use `ext4` as filesystem it will reserve some space automatically; such space may be too much: you can lower it with `tune2fs`.
For example, to reserve only 8 GiB (when the block size is of 4 KiB):

```bash
tune2fs -r $((1024*1024*2)) /dev/sdxN
```

```nix "PereBook/home/backup" +=
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
        "*/.vim*.tmp"
        ".npm"
        "node_modules"
      ];
    };
  };
  # TODO wait home-manager update
  # hooks.extraConfig = {
  #   # do not execute if destination is unmounted
  #   before_backup = "findmnt ${mntPoint} > /dev/null || exit 75";
  # };
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
```

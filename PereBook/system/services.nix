{ config, pkgs, users, lib, ... }:
{
  programs.adb.enable = true;
  users.users = lib.genAttrs users (user: {
    extraGroups = [
      "adbusers"
    ];
  });
}

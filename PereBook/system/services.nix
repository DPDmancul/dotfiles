{ config, pkgs, lib, ... }:
{
  programs.adb.enable = true;
  users.users.default.extraGroups = [
    "adbusers"
  ];
}

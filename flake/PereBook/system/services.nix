{ config, pkgs, users, lib, ... }:
{
  users.users = lib.genAttrs users (user: {
    extraGroups = [
      "adbusers"
    ];
  });

  environment.systemPackages = with pkgs; [
    android-tools
  ];
}

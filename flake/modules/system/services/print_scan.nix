{ config, pkgs, users, lib, ... }:
{
  services.printing.enable = true;
  programs.system-config-printer.enable = true;
  hardware.sane.enable = true;
  users.users = lib.genAttrs users (user: {
    extraGroups = [
      "scanner"
      "lp"
    ];
  });
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
}

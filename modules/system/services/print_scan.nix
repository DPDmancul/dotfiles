{ config, pkgs, lib, ... }:
{
  services.printing.enable = true;
  programs.system-config-printer.enable = true;
  hardware.sane.enable = true;
  users.users.default.extraGroups = [
    "scanner"
    "lp"
  ];
}

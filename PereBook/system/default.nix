{ config, pkgs, inputs, secrets, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-pc-laptop-hdd
    common-cpu-intel
    common-gpu-intel
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
    ./services.nix
    /${modules}/system/services/print_scan/brotherDCP1612W.nix
    ./users.nix
  ];

  fileSystems."/home/dpd-/datos" = {
    device = "/dev/disk/by-uuid/42681448-3710-4f0b-9778-994a23c7f17e";
    fsType = "ext4";
    options = [ "noatime" ];
  };
  fileSystems."/".options = [ "compress=zstd" ];
  hardware.opentabletdriver.enable = true;
  time.timeZone = "Europe/Rome";
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
  };
  security.pam.services.swaylock = {
    text = "auth include login";
  };
}

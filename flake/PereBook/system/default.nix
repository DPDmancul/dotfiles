{ config, pkgs, inputs, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    # T16 and P16s gen4 with AMD are the same
    lenovo-thinkpad-p16s-amd-gen4
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./disko.nix
    ./net.nix
    ./services.nix
    /${modules}/system/services/print_scan/brotherDCP1612W.nix
    ./users.nix
  ];

  services.btrfs.autoScrub.enable = true;
  services.tlp = {
    enable = true;
    pd.enable = true;
  };
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 45;
    STOP_CHARGE_THRESH_BAT0 = 60;
  };
}

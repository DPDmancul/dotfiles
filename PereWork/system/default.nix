{ config, pkgs, inputs, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
    # lenovo-thinkpad-p50 # not imported to use nouveau drivers instead of proprietary ones
    common-pc-laptop-acpi_call
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
    /${modules}/system/sway.nix
    ./users.nix
    ./docker.nix
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  fileSystems."/".options = [ "compress=zstd" ];
}

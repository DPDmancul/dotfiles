{ config, pkgs, inputs, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    # TODO:
    # common-pc-laptop-ssd
    # common-pc-laptop-hdd
    # common-cpu-intel
    # common-gpu-intel
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
    /${modules}/system/sway.nix
    ./users.nix
  ];

  fileSystems."/".options = [ "compress=zstd" ];
}

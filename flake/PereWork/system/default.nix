{ config, pkgs, inputs, modules, sops, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
    lenovo-thinkpad-p50
    common-pc-laptop-acpi_call
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./users.nix
    ./autorandr.nix
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  fileSystems."/".options = [ "compress=zstd" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime.offload.enable = false;
  networking.hosts = {
    "10.14.201.215" = [ "k8sd-plant-jft-mvlabs.vidim.it" ];
  };
  sops.secrets."ca/PereWork.pem" = {};
  security.pki.certificateFiles = [ config.sops.secrets."ca/PereWork.pem".path ];
}

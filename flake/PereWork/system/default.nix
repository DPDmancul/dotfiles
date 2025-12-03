{ config, pkgs, inputs, modules, sops, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    lenovo-thinkpad-p50
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
    ./users.nix
    ./autorandr.nix
  ];

  hardware = {
    enableAllFirmware = false;
    firmware = with pkgs.unfree; [
      broadcom-bt-firmware
      b43Firmware_5_1_138
      b43Firmware_6_30_163_46
      xow_dongle-firmware
      facetimehd-firmware
      facetimehd-calibration
    ];
  };
  virtualisation = {
    libvirtd.enable = true;
    # virtualbox.host.enable = true;
  };
  fileSystems."/".options = [ "compress=zstd" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime.offload.enable = false;
  networking.hosts = {
    "10.14.201.215" = [ "k8sd-plant-jft-mvlabs.vidim.it" ];
    "192.168.69.2" = [ "k8sd-topbest-imel.i4paintshop.com" "argocd-topbest-imel.i4paintshop.com" "pgad-topbest-imel.i4paintshop.com" ];
    "192.168.3.245" = [ "sg.inplant.live" "sg.inplant.io" ];
  };
  services.teamviewer.enable = true;
  sops.secrets."ca/PereWork.pem" = {};
  # security.pki.certificateFiles = [ config.sops.secrets."ca/PereWork.pem".path ];
}

{ config, pkgs, inputs, modules, sops, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    # lenovo-thinkpad-p16s-intel-gen3:
    common-cpu-intel#-arrow-lake
    common-gpu-intel#-arrow-lake
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./disko.nix
    ./net.nix
    ./users.nix
    ./autorandr.nix
  ];

  virtualisation = {
    # libvirtd.enable = true;
    # virtualbox.host.enable = true;
  };
  services.btrfs.autoScrub.enable = true;
  services.tlp = {
    enable = true;
    pd.enable = true;
  };
  networking.hosts = {
    "10.14.201.215" = [ "k8sd-plant-jft-mvlabs.vidim.it" ];
    "192.168.69.2" = [ "k8sd-topbest-imel.i4paintshop.com" "argocd-topbest-imel.i4paintshop.com" "pgad-topbest-imel.i4paintshop.com" ];
    "192.168.3.245" = [ "sg.inplant.live" "sg.inplant.io" ];
  };
  # services.teamviewer.enable = true;
  sops.secrets."ca/PereWork.pem" = {};
  # security.pki.certificateFiles = [ config.sops.secrets."ca/PereWork.pem".path ];
}

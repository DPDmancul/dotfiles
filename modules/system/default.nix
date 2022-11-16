{ config, pkgs, lib, ... }:
{
  imports = [
    ./flakes.nix
    ./boot.nix
    ./i18n.nix
  ];

  fileSystems."/".options = [ "noatime" ];
  systemd.enableEmergencyMode = false;
  hardware.opengl.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "21.11";
}

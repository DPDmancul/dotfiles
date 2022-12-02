{ config, pkgs, users, lib, ... }:
{
  imports = [
    ./flakes.nix
    ./boot.nix
    ./i18n.nix
    ./services.nix
    ./services/pipewire.nix
    ./services/print_scan.nix
    ./packages.nix
  ];

  users.users = lib.genAttrs users (user: {
    extraGroups = [
      "input"
      "video"
      "networkmanager"
    ];
  });

  fileSystems."/".options = [ "noatime" ];
  systemd.enableEmergencyMode = false;
  hardware.opengl.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  networking.networkmanager.enable = true;
  users.mutableUsers = false;
  time.timeZone = "Europe/Rome";
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "21.11";
}

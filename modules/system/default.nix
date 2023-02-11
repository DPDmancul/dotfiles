{ config, pkgs, users, lib, assets, ... }:
{
  imports = [
    ./flakes.nix
    ./boot.nix
    ./i18n.nix
    ./services
    ./services/pipewire.nix
    ./services/print_scan.nix
    ./lightdm.nix
    ./packages.nix
  ];

  sops.defaultSopsFile = /${assets}/secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

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

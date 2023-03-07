{ config, pkgs, users, lib, assets, ... }:
{
  imports = [
    ./flakes.nix
    ./boot.nix
    ./i18n.nix
    ./services
    ./services/net.nix
    ./services/pipewire.nix
    ./services/print_scan.nix
    ./lightdm.nix
    ./i3.nix
    ./packages.nix
  ];

  sops.defaultSopsFile = /${assets}/secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  users.users = lib.genAttrs users (user: {
    extraGroups = [
      "input"
      "video"
    ];
  });

  fileSystems."/".options = [ "noatime" ];
  systemd.enableEmergencyMode = false;
  hardware.opengl.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  users.mutableUsers = false;
  programs.dconf.enable = true;
  time.timeZone = "Europe/Rome";
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "21.11";
}

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
    ./services/docker.nix
    ./gdm.nix
    ./i3.nix
    ./niri.nix
    ./keyring.nix
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

  networking.firewall = {
    allowedUDPPorts = [ 53317 ];
    allowedTCPPorts = [ 53317 ];
  };
  fileSystems."/".options = [ "noatime" ];
  systemd.enableEmergencyMode = false;
  hardware.graphics.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  users.mutableUsers = false;
  programs.dconf.enable = true;
  time.timeZone = "Europe/Rome";
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "JetBrainsMono" ];
      };
    };
  };
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "21.11";
}

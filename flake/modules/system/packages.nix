{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    bottom
    lsd      # ls with colors and icons (TODO config)
    fd       # faster find
    ripgrep  # alternative grep
    usbutils
    pciutils
    file
    sops
    zip
    unzip
    p7zip
    xdg-utils
    wget
    git
    gnumake
    gcc
  ];
  networking.hosts."0.0.0.0" = ["get.code-industry.net"];
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.bat.enable = true; # cat with syntax highlighting
}

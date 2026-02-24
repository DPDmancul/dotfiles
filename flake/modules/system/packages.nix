{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    bottom
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
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.bat.enable = true;      # cat with syntax highlighting
  programs.lsd.enable = true;      # ls with colors and icons (TODO config)
  programs.fd.enable = true;       # faster find
  programs.ripgrep.enable = true;  # alternative grep
}

{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    bottom
    bat      # cat with syntax highlighting
    lsd      # ls with colors and icons (TODO config)
    tldr     # short command examples
    fd       # faster find
    ripgrep  # alternative grep
    usbutils
    pciutils
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
}

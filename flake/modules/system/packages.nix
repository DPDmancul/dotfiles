{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    bottom
    bat      # cat with syntax highlighting
    lsd      # ls with colors and icons (TODO config)
    tealdeer # tldr: short command examples
    fd       # faster find
    ripgrep  # alternative grep
    usbutils
    pciutils
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
}

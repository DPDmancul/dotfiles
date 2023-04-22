{ config, pkgs, lib, user, dotfiles, assets, ... }:
{
  imports = [
    ./kitty.nix
    ./fish.nix
    ./nvim
    ./i3
    ./theme.nix
    ./firefox.nix
    ./xdg.nix
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./packages
  ];

  home.username = user;
  home.homeDirectory = "/home/${config.home.username}";
  xsession.numlock.enable = true;
  home.packages = [
    (pkgs.writeShellScriptBin "dots" ''
      cd "${dotfiles}"
      nix-shell --run "make $*"
    '')
  ];
  home.stateVersion = "22.05";
}

{ config, pkgs, lib, user, dotfiles, assets, ... }:
{
  imports = [
    ./kitty.nix
    ./fish.nix
    ./fzf.nix
    ./zoxide.nix
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
  home.sessionVariables.SOPS_AGE_KEY_CMD = "sudo cat /var/lib/sops-nix/key.txt";
  home.stateVersion = "22.05";
}

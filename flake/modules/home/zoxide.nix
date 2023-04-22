{ config, pkgs, lib, ... }:
{
  programs = {
    zoxide.enable = true;
    fzf.enable = true;
  };
}

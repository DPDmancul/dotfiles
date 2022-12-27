{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./git.nix
    ./ssh.nix
    ./sway.nix
    ./rider.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}

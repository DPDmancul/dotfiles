{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./ssh.nix
    ./sway.nix
    ./rider.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}

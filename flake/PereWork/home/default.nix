{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./git.nix
    ./ssh.nix
    ./firefox.nix
    /${modules}/home/packages/qemu.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}

{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    qemu
    virt-manager
  ];
}

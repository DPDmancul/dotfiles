{ config, pkgs, lib, inputs, ... }:
{
  home.packages = with pkgs; [
    unfree.unstable.jetbrains.phpstorm
  ];
}

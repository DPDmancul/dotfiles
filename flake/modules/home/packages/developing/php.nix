{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    php
  ];

  nvimLSP.phpactor = pkgs.phpactor;
}

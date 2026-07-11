{ config, pkgs, lib, ... }:
{
  programs.go = {
    enable = true;
    telemetry.mode = "off";
  };

  nvimLSP.gopls = pkgs.gopls;
}

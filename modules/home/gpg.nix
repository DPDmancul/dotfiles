{ config, pkgs, lib, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
}

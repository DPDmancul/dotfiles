{ config, pkgs, lib, ... }:
{
  imports = [
    ./tideOptions.nix
  ];

  programs.fish.tide = {
    enable = true;
    style = "lean";
    config = {
      left_prompt.frame_enabled = "true";
    };
  };
}

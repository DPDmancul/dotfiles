{ config, pkgs, lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = "╭─$all╰─$jobs$character";
      right_format = "$status";
      directory.home_symbol = "🏠"; # Nerd font variant: 
      status = {
        disabled = false;
        map_symbol = true;
      };
    };
  };
}

{ config, pkgs, lib, ... }:
{
  programs = {
    fd.enable = true;
    lsd.enable = true;
    fzf = {
      enable = true;

      defaultCommand = "fd";

      # CTRL-T
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [
        "--preview '${pkgs.fzf-preview}/bin/fzf-preview {}'" # TODO images
      ];

      # ALT-C
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'lsd --tree --color always --icon always --depth 2 {} | head -200'"
      ];
    };
  };
}

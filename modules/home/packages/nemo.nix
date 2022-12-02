{ config, pkgs, lib, ... }:
{
  imports = [
    ../xdg.nix
  ];

  home.packages = with pkgs; [
    cinnamon.nemo
    shared-mime-info
  ];

  appDefaultForMimes."nemo.desktop" = "inode/directory";

  dconf.settings."org/cinnamon/desktop/applications/terminal".exec = "kitty";
  dconf.settings."org/cinnamon/desktop/default-applications/terminal".exec = "kitty";

  dconf.settings."org/nemo/desktop".show-desktop-icons = false;
}

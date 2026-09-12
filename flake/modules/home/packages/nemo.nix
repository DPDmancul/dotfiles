{ config, pkgs, lib, ... }:
{
  imports = [
    ../xdg.nix
  ];

  home.packages = with pkgs; [
    (nemo-with-extensions.override {
      useDefaultExtensions = false;
      extensions = [
        nemo-fileroller
      ];
    })
    shared-mime-info
    libheif
    libheif.out
    ffmpegthumbnailer
  ];

  appDefaultForMimes."nemo.desktop" = "inode/directory";

  dconf.settings."org/cinnamon/desktop/applications/terminal".exec = "kitty";
  dconf.settings."org/cinnamon/desktop/default-applications/terminal".exec = "kitty";

  dconf.settings."org/nemo/desktop".show-desktop-icons = false;
}

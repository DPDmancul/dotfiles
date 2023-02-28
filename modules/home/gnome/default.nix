{ config, pkgs, lib, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/wm/preferences".focus-mode = "mouse";
    "org/gnome/settings-daemon/plugins/color".night-light-enabled = true;

    # TODO organize
    "org/gnome/desktop/screensaver".lock-enabled = false; # Do not lock after screen off
    "org/gnome/desktop/wm/preferences".resize-with-right-button = true;
    "org/gnome/mutter".dynamic-workspaces = true;
    "org/gnome/desktop/input-sources".sources = [(lib.hm.gvariant.mkTuple ["xkb" "eu"])];
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        # "forge@jmmaranan.com"
        "pop-shell@system76.com"
        "blur-my-shell@aunetx"
        "rounded-window-corners@yilozt"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/terminal/legacy/settings".headerbar = false; # TODO
  };

  home.packages = with pkgs; [
    unstable.gnomeExtensions.forge
    gnomeExtensions.blur-my-shell
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.pop-shell
    xclip # TODO move
  ];
}

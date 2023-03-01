{ config, pkgs, lib, ... }: let
  # TODO create my lib
  concatMapToAttrs = f: with lib; flip pipe [ (map f) (foldl' mergeAttrs { }) ];
in
{
  services.picom = {
    enable = true;
    backend = "glx";
    settings = {
      corner-radius = 10;
      round-borders = 1;
    };
    shadow = true;
    shadowExclude = [
      # i3 tabs
      "class_g = 'i3-frame'"
      # Telegram context menu
      "_NET_WM_WINDOW_TYPE:a *= '_KDE_NET_WM_WINDOW_TYPE_OVERRIDE'"
    ];
    wintypes = concatMapToAttrs (type: {
      ${type} = {
        shadow = false;
      };
    }) [
      "dock"
      "desktop"
      "menu"
      "dropdown_menu"
      "popup_menu"
      "tooltip"
      "i3-frame"
    ];
    opacityRules = [
      "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
    ];
  };
}

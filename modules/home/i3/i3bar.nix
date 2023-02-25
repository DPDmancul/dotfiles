{ config, pkgs, lib, ... }:
{
  xsession.windowManager.i3.config.bars = [ 
    {
      position = "top";

      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config.toml";

      fonts = {
        names = [ "pango:JetbrainsMono Nerd Font" ];
        size = 9.;
      };

      command = "i3bar -t"; # enable transaprencies

      colors = {
        background = "#00000000";
        inactiveWorkspace = {
          background = "#F9F9F9A5";
          border = "#00000000";
          text = "#000000";
        };
        activeWorkspace = { # ????
          background = "#F9F9F966";
          border = "#00000000";
          text = "#000000";
        };
        focusedWorkspace = {
          background = "#F9F9F966";
          # background = "#A1A1A1A5";
          border = "#00000000";
          text = "#000000";
        };
        urgentWorkspace = {
          background = "#FFAA00A5";
          border = "#00000000";
          text = "#000000";
        };
        bindingMode = {
          background = "#E8A2AFA5";
          border = "#00000000";
          text = "#000000";
        };
      };
    }
  ];

  programs.i3status-rust = {
    enable = true;
  };
  # TODO

#run: xfce4-panel --sm-client-disable

  # xfconf.settings.xfce4-panel = {
  #   "panels" = [ 1 ];
  #   "panels/dark-mode" = false;
  #   # for p value see: https://git.xfce.org/xfce/xfce4-panel/tree/libxfce4panel/libxfce4panel-enums.h#n80
  #   "panels/panel-1/position" = "p=2;x=0;y=0";
  #   "panels/panel-1/length" = 100;
  #   "panels/panel-1/position-locked" = true;
  #   "panels/panel-1/icon-size" = 16;
  #   "panels/panel-1/size" = 20;
  #
  #   "panels/panel-1/plugin-ids" = [ 1 3 4 3 5 6 7 8];
  #
  #   "plugins/plugin-1" = "i3-workspaces";
  #
  #   "plugins/plugin-3" = "separator";
  #   "plugins/plugin-3/style" = 0; # transparent
  #   "plugins/plugin-3/expanded" = true;
  #
  #   "plugins/plugin-4" = "windowck";
  #
  #   "plugins/plugin-5" = "pulseaudio";
  #   "plugins/plugin-5/enable-keyboard-shortcuts" = false;
  #
  #   "plugins/plugin-6" = "battery";
  #
  #   "plugins/plugin-7" = "clock";
  #   "plugins/plugin-7/digital-format" = "%H:%M";
  #
  #   "plugins/plugin-8" = "systray";
  # };
}

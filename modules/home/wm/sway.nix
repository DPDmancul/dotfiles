{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./default.nix
    ./waybar.nix
  ];

  config = let
    inherit (config.wayland.windowManager.sway.config) modifier left down up right;
  in
  {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        input."*" = {
          xkb_layout = "eu"; # TODO take from system config
          xkb_numlock = if config.xsession.numlock.enable then "enabled" else "disabled";
        };
      };
      extraConfig = ''
        exec ${pkgs.unstable.wpaperd}/bin/wpaperd
      '';
    };

    home.packages = with pkgs; [
      swaylock-effects
      sway-contrib.grimshot
      wl-clipboard
      # wl-clipboard-x11
      unstable.wpaperd
    ];

    home.sessionVariables.XDG_CURRENT_DESKTOP = "sway";
    sway-i3AddKeybinds."Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
    services.swayidle = {
      enable = true;
      timeouts = [{
        timeout = 300;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }];
    };
    sway-i3AddNamedKeybinds.grimshot = lib.concatMapAttrs (key: func: {
      "${modifier}+${key}" = "exec grimshot ${func} active";       # Active window
      "${modifier}+Shift+${key}" = "exec grimshot ${func} area";   # Select area
      "${modifier}+Mod1+${key}" = "exec grimshot ${func} output";  # Whole screen
      "${modifier}+Ctrl+${key}" = "exec grimshot ${func} window";  # Choose window
    }) { p = "save"; y = "copy"; };
    xdg.configFile."wpaperd/output.conf".text = ''
      [default]
      path = "${inputs.wallpapers}"
      duration = "1m"
    '';
  };
}

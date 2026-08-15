{ config, pkgs, lib, ... }:
let
  inherit (config.xsession.windowManager.i3.config) modifier;
  alt = "Mod1";
in
{
  imports = [
    ./keybinds.nix
    ./picom.nix
    ./polybar.nix
  ];

  xsession = {
    enable = true; # .xsession for lightDM
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "kitty";
        menu = "rofi -show drun";
        floating.criteria =[
          { class = "[Ff]irefox"; title = "^Developer Tools [-—]"; }
          { class = "[Ff]ile-roller"; title = "Extract"; }
          { class = "[Ff]ile-roller"; title = "Compress"; }
          { title = "file Transfer.*"; }
          { class = "[Nn]emo"; title = "Properties"; }
          { class = "[Pp]avucontrol"; }
          { class = "[Qq]alculate-gtk"; }
          { class = "[Cc]opyq"; }
          { title = "MuseScore: Play Panel"; }
        ];
        window.commands = [
          { criteria = { class = "[Ff]irefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
          { criteria = { class = "[Ff]irefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
        ];
        gaps.inner = 5;
        window.border = 0;
        floating.border = 0;
        window.titlebar = false;
        floating.titlebar = false;
        startup = [
          {
            command = "dbus-update-activation-environment --all";
            notification = false;
          }
        ];
      };
    };
  };

  programs.rofi = {
    enable = true;
    terminal = config.xsession.windowManager.i3.config.terminal;
    extraConfig = {
      show-icons = true;
    };
    theme = with config.lib.formats.rasi; {
      "@import" = "gruvbox-light";
      window.border = mkLiteral "none";
    };
  };
  services.dunst = {
    enable = true;
    iconTheme = {
      inherit (config.gtk.iconTheme) name package;
    };
    settings = {
      global = {
        follow = "mouse";
        corner_radius = config.services.picom.settings.corner-radius;
      };
    };
  };
  services.gammastep = {
    enable = true;
    latitude = 46.; # North
    longitude = 13.; # East
    tray = false;
  };
  i3AddKeybinds."Ctrl+${alt}+l" = ''exec --no-startup-id "i3lock-color --clock --indicator --blur 7x5 --pass-{media,screen,power,volume}-keys"'';
  i3AddNamedKeybinds.scrot = lib.concatMapAttrs (key: fn: {
    "--release ${modifier}+${key}" = fn "-zpu";        # Focused window
    "--release ${modifier}+Shift+${key}" = fn "-zpfs"; # Select area or window
    "--release ${modifier}+Ctrl+${key}" = fn "-zp";    # Whole screen
  }) {
    p = let dir = "${config.xdg.userDirs.pictures}/Screenshots";
        in args: "exec --no-startup-id mkdir -p ${dir} && scrot ${args} -F '${dir}/%Y-%m-%d_%H%M%S.png'";
    y = args: "exec --no-startup-id scrot ${args} - | xclip -selection clipboard -t image/png";
  };
  services.copyq.enable = true;
  home.activation.copyqConfig = lib.hm.dag.entryAfter ["writeBoundary"] (
    lib.concatLines (
      lib.mapAttrsToList (k: v:
        "run --quiet ${config.services.copyq.package}/bin/copyq --start-server config ${k} ${toString v} 2> >(grep -v '^Warning: CopyQ server is already running' >&2)"
      )
      {
        disable_tray = true;
        hide_main_window = true; # when closed
        hide_tabs = true;
        hide_toolbar = true;
        autostart = false;
      }
    )
  );
  i3AddKeybinds."${modifier}+q" = "exec copyq toggle";

  home.packages = with pkgs; [
    i3lock-color
    scrot
    xclip
    polkit_gnome
  ];
}

{ config, pkgs, lib, ... }: let
  barName = "top";
in
{
  xsession.windowManager.i3.config.bars = [];

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    settings = rec {
      colors = {
        background = "#0000";
        foreground = "#161320";
        glass = "#A6F9F9F9";
        gold-opaque = "#EFB402";
        gold-opaque-dark = "#AB8203";
        red-opaque = "#E00804";
        gray-opaque = "#333";
        red = "#A6E8A2AF";
        purple = "#A6C9CBFF"; #idle
          yellow = "#A6FAE3B0";
        violet = "#A6BD93F9";
        lilla = "#A6DDB6F2";
        cyan = "#A696CDFB";
        salmon = "#A6F8BD96"; # temp
          azure = "#A6B5E8E0";
        green = "#A6ABE9B3";
      };
      "bar/${barName}" = {
        monitor = "\${env:MONITOR:}";

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        height = "20px";
        border = {
          top.size = "4px";
          bottom.size = 0;
        };
        padding = "6px";

        module.margin = "4px";

        line.size = "4px"; # colored line under active workspace
        font = [
          # T1: text
          "JetbrainsMono Nerd Font:size=9;2"
          # T2: powerline
          "JetbrainsMono Nerd Font:antialias=false:size=11;2"
        ];

        modules = {
          left = "i3";
          center = "window";
          right = "volume vpn eth wlan ram cpu battery clock"; # TODO idle
        };
        tray.position = "right";
      };
      rounded = lib.concatMapToAttrs (spec: {
        ${spec} = {
          prefix = {
            foreground = "\${self.${spec}-background}";
            background = "#0000";
            text = "";
            font = 2;
          };
          suffix = {
            foreground = "\${self.${spec}-background}";
            background = "#0000";
            text = "";
            font = 2;
          };
        };
      }) [
        "format"
        "format-volume"
        "format-muted"
        "format-mounted"
        "format-unmounted"
        "format-connected"
        "format-disconnected"
        "content"
      ];
      "module/i3" = {
        type = "internal/i3";
        pin.workspaces = true; # show only this monitor ws
        enable.scroll = false;

        label = lib.concatMapToAttrs (spec: {
          ${spec} = {
            text = "%index%"; # do not show icon
            padding = "4px";
            background = "\${colors.glass}";
          };
        }) [
          "focused"
          "visible" # focused on antoher monitor
          "unfocused"
          "urgent"
        ];

        label-focused = {
          foreground = "\${colors.gold-opaque-dark}";
          underline = "\${colors.gold-opaque}";
        };
        label-visible = {
          foreground = "\${colors.gray-opaque}";
          underline = "\${colors.gray-opaque}";
        };
        label-urgent = {
          foreground = "\${colors.red-opaque}";
          underline = "\${colors.red-opaque}";
        };

        label-mode.background = "\${colors.red}";
        format = "%{B#0000 F${colors.glass} T2}%{B${colors.glass} F${colors.foreground} T-}<label-state>%{B#0000 F${colors.glass} T2}%{B- F- T-} <label-mode>";
        label-mode.text = "%{B#0000 F${colors.red} T2}%{B${colors.red} F${colors.foreground} T-}%mode%%{B#0000 F${colors.red} T2}%{B- F- T-}";
      };
      "module/window" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
        "inherit" = "rounded";
        format.background = "\${colors.glass}";
      };
      "module/volume" = {
        type = "internal/pulseaudio";
        "inherit" = "rounded";
        format = {
          volume.text = "<ramp-volume> <label-volume>";
          volume.background = "\${colors.yellow}";
          muted.background = "\${colors.yellow}";
        };
        ramp.volume = [ "" "" "" ];
        label.muted = " ";
        click.right = "pavucontrol";
      };
      net = {
        type = "internal/network";
        label.disconnected = "";
        format = {
          connected.background = "\${colors.violet}";
          disconnected.background = "\${colors.red}";
        };
        # TODO show ip on click
      };
      "module/eth" = {
        "inherit" = "net rounded";
        interface.type = "wired";
        label.connected = " %linkspeed%";
      };
      "module/wlan" = {
        "inherit" = "net rounded";
        interface.type = "wireless";
        label.connected = " %essid:0:10:...% (%signal%%)";
      };
      "module/vpn" = {
        "inherit" = "net rounded";
        interface = "tun0";
        label.connected = "";
      };
      "module/ram" = {
        type = "internal/memory";
        interval = 5;
        label = " %percentage_used%%";
        "inherit" = "rounded";
        format.background = "\${colors.lilla}";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 5;
        label = " %percentage%%";
        "inherit" = "rounded";
        format.background = "\${colors.cyan}";
      };
      "module/battery" = rec {
        type = "internal/battery";
        time.format = "%H:%M";
        format = {
          charging = "<animation-charging> <label-charging>";
          discharging = "<ramp-capacity> <label-discharging>";
          full = "<ramp-capacity> <label-full>";
        };
        ramp.capacity = [ "" "" "" "" "" ];
        animation.charging = ramp.capacity;
        "inherit" = "rounded";
        format.background = "\${colors.azure}";
      };
      "module/clock" = {
        type = "internal/date";
        date = {
          text = "%H:%M";
          alt = "%Y-%m-%d %H:%M:%S";
        };
        "inherit" = "rounded";
        format.background = "\${colors.green}";
      };
      settings.screenchange.reload = true;
    };
  };

 services.polybar.script = ''
   for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
     MONITOR=$m polybar ${barName} &
   done
 '';
 # systemd.user.services.polybar.Unit.After = [ "graphical-session.target" ]; # TODO: not solving

 # Temporary fix: restart polybar
 xsession.windowManager.i3.config.startup = [
   { command = "systemctl --user restart polybar"; always = true; notification = false; }
 ];
 programs.autorandr = {
   enable = true;
   hooks.postswitch = {
     "reload-polybar" = "systemctl --user restart polybar";
   };
 };
}

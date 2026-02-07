# ashell

The top bar

```nix modules/home/niri/ashell.nix
{ config, pkgs, lib, ... }:
{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      modules = {
        left = [
          "Workspaces"
        ];
        center = [
          "Window Title"
        ];
        right = [
          "SystemInfo"
          [
            "Tray"
            "MediaPlayer"
            "Privacy"
            "Settings"
          ]
          "Clock"
        ];
      };
      workspaces.visibility_mode = "MonitorSpecific";
      system_info.indicators = ["Cpu" "Memory"];
      clock.format = "%H:%M";
      lock_cmd = "swaylock &";
      audio_sinks_more_cmd = "pavucontrol -t 3";
      audio_sources_more_cmd = "pavucontrol -t 4";
      wifi_more_cmd = "kitty nmtui";
      bluetooth_more_cmd = "blueman-manager";
      remove_airplane_btn = true;
      indicators = ["IdleInhibitor" "PowerProfile" "Audio" "Bluetooth" "Network" "Vpn" "PeripheralBattery" "Battery"];

      opacity = "0.65";
      apparence = {
        success_color = "#a6e3a1";
        text_color = "#cdd6f4";

        workspace_colors = [ "#fab387" "#b4befe" "#cba6f7" ];

        primary_color = {
          base = "#fab387";
          text = "#161320";
        };

        danger_color = {
          base = "#f38ba8";
          weak = "#f9e2af";
        };

        background_color = {
          base = "#F9F9F9";
          weak = "#FAE3B0";
          strong = "#DDB6F2";
        };

        secondary_color = {
          base = "#F8BD96";
          strong = "#1b1b25";
        };
      };
    };
  };
}
```

{ config, pkgs, lib, ... }:
{
  imports = [
    ./keybinds.nix
    ./windows.nix
    ./ashell.nix
  ];

  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard {
        numlock
      }

      touchpad {
        tap
        dwt // disable when typing
        drag true
        drag-lock
        scroll-method "two-finger"
      }

      focus-follows-mouse max-scroll-amount="10%"
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
  '';

  programs.fuzzel = {
    enable = true;
    settings.colors = {
      background = "fbf1c7ff";
      text = "3c3836ff";
      match = "9d0006ff";
      selection = "ebdbb2ff";
      selection-text = "3c3836ff";
      selection-match = "9d0006ff";
      border = "af3a0300";
    };
  };
  services.mako = {
    enable = true;
    settings = {
      border-radius = 12;
      icon-path = "${config.gtk.iconTheme.package}/usr/share/icons/${config.gtk.iconTheme.name}";
    };
  };
  services.gammastep = {
    enable = true;
    latitude = 46.; # North
    longitude = 13.; # East
    tray = false;
  };
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      effect-blur = "7x5";
      fade-in = 0.2;
    };
  };
  services.copyq = {
    enable = true;
    forceXWayland = false;
  };
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        # resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };

  home.packages = with pkgs; [
    niri
    polkit_gnome
    # swaybg
    xwayland-satellite
    # <<<modules/home/niri-packages>>>
  ];
}

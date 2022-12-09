{ config, pkgs, lib, dotfiles, ... }:
{
  imports = [
    ./waybar.nix
  ];
  options = {
    swayAddKeybinds =  with lib; mkOption {
      type = with types; attrsOf str;
      description = "Additional keybindings to the default ones.";
      default = { };
    };
    swayAddNamedKeybinds = with lib; mkOption {
      type = with types; attrsOf (attrsOf str);
      description = "Additional keybindings to the default ones.
        The keybinds are collected in a set whose names are discarded,
        and so can be used for organization purpose.";
      default = { };
      apply = x: (lib.concatMapAttrs (name: value: value) x) // config.swayAddKeybinds;
    };
  };
  config = let
    inherit (config.wayland.windowManager.sway.config) modifier left down up right;
  in
  {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod4";
        input."*".xkb_layout = "eu";
        input."*".xkb_numlock = "enabled";
        terminal = "kitty";
        menu = ''wofi --show=drun -i --prompt=""'';
        floating.criteria = [
          { app_id = "firefox"; title = "^Developer Tools [-—]"; }
          { app_id = "file-roller"; title = "Extract"; }
          { app_id = "file-roller"; title = "Compress"; }
          { app_id = "nemo"; title = "Properties"; }
          { app_id = "pavucontrol"; }
          { app_id = "qalculate-gtk"; }
          { app_id = "copyq"; }
        ];
        window.commands = [
          { criteria = { app_id = "firefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
          { criteria = { app_id = "firefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
          { criteria = { shell = "xwayland"; }; command = ''title_format "%title [%shell]"''; } # TODO: does not work for waybar
        ];
        gaps.inner = 5;
        colors.unfocused = let transparent = "#00000000"; in {
          background = "#222222";
          border = transparent;
          childBorder = transparent;
          indicator = "#292d2e";
          text = "#888888";
        };
        gaps.smartBorders = "on";
        keybindings = lib.mkOptionDefault config.swayAddNamedKeybinds;
      };
      extraConfig = ''
        exec ${pkgs.copyq}/bin/copyq
        exec ${pkgs.wpaperd}/bin/wpaperd
      '';
    };

    home.packages = with pkgs; [
      wofi
      swaylock-effects
      sway-contrib.grimshot
      wl-clipboard
      wl-clipboard-x11
      copyq
      polkit_gnome
      wpaperd
    ];

    home.sessionVariables.XDG_CURRENT_DESKTOP = "sway";
    programs.fish.loginShellInit = lib.mkBefore ''
      if test (tty) = /dev/tty1
        exec sway &> /dev/null
      end
    '';
    xdg.configFile."wofi/config".text = ''
      allow_images=true # Enable icons
      insensitive=true  # Case insensitive search
    '';
    swayAddKeybinds."${modifier}+Shift+e" = ''
      exec sh -c ' \
        case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | wofi --dmenu -i --prompt="Logout menu") in \
          "Shutdown") systemctl poweroff;; \
          "Suspend") systemctl suspend;; \
          "Reboot") systemctl reboot;; \
          "Logout") swaymsg exit;; \
        esac \
      '
    '';
    programs.mako = {
      enable = true;
    };
    swayAddKeybinds = {
      "--locked XF86AudioRaiseVolume" = "exec pamixer -u -i 5";
      "--locked XF86AudioLowerVolume" = "exec pamixer -d 5";
      "--locked XF86AudioMute" = "exec pamixer -t";
    };
    swayAddKeybinds = {
      "--locked XF86MonBrightnessDown" = "exec light -U 2";
      "--locked XF86MonBrightnessUp" = "exec light -A 2";
    };
    services.wlsunset = {
      enable = true;
      latitude = "46"; # North
      longitude = "13"; # East
    };
    services.kanshi = {
      enable = true;
    };
    swayAddNamedKeybinds.moveToScreen = with lib; listToAttrs (concatMap ({ left, down, up, right }: [
        (nameValuePair "${modifier}+Ctrl+Shift+${left}" "move workspace to output left")
        (nameValuePair "${modifier}+Ctrl+Shift+${down}" "move workspace to output down")
        (nameValuePair "${modifier}+Ctrl+Shift+${up}" "move workspace to output up")
        (nameValuePair "${modifier}+Ctrl+Shift+${right}" "move workspace to output right")
      ]) [
        { inherit left down up right; }
        { left = "Left"; down = "Down"; up = "Up"; right = "Right"; }
      ]
    );
    swayAddNamedKeybinds.additionalWS = with lib; listToAttrs (concatMap
      ({ name, value }:
        let
          ws = toString value;
        in
        [
          (nameValuePair "${modifier}+${name}" "workspace number ${ws}")
          (nameValuePair "${modifier}+Shift+${name}" "move container to workspace number ${ws}")
          (nameValuePair "${modifier}+Ctrl+${name}" "move container to workspace number ${ws}, workspace number ${ws}")
        ])
      ([
        (nameValuePair "grave" 0)
        (nameValuePair "Escape" 10)
      ] ++ (map
        (n: nameValuePair (toString n) n)
        [ 1 2 3 4 5 6 7 8 9 ])
      ++ map
        (n: nameValuePair "F${toString n}" (10 + n))
        [ 1 2 3 4 5 6 7 8 9 10 11 12 ]
      )
    );
    swayAddKeybinds."Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
    services.swayidle = {
      enable = true;
      timeouts = [{
        timeout = 300;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }];
    };
    swayAddNamedKeybinds.grimshot = lib.concatMapAttrs (key: func: {
      "${modifier}+${key}" = "exec grimshot ${func} active";       # Active window
      "${modifier}+Shift+${key}" = "exec grimshot ${func} area";   # Select area
      "${modifier}+Mod1+${key}" = "exec grimshot ${func} output";  # Whole screen
      "${modifier}+Ctrl+${key}" = "exec grimshot ${func} window";  # Choose window
    }) { p = "save"; y = "copy"; };
    swayAddNamedKeybinds.shortcuts = {
      "${modifier}+z" = "exec firefox";
      "${modifier}+x" = "exec nemo";
      "${modifier}+v" = "exec kitty nvim";
    };
    swayAddKeybinds."${modifier}+q" = "exec copyq toggle";
    xdg.configFile."wpaperd/output.conf".text = ''
      [default]
      path = "${dotfiles}/flake/wallpapers"
      duration = "1m"
    '';
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = {
        name = "adwaita";
        package = pkgs.adwaita-qt;
      };
    };
    gtk.enable = true;
    gtk.iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
    dconf.settings."org/gnome/desktop/interface" = {
      icon-theme = config.gtk.iconTheme.name;
    };
    home.pointerCursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}

{ config, pkgs, lib, inputs, ... }:
let
  inherit (config.xsession.windowManager.i3.config) modifier;
  alt = "Mod1";
  vi-directions = {
    left = "h";
    down = "j";
    up = "k";
    right = "l";
  };
  arrow-directions = {
    left = "Left";
    down = "Down";
    up = "Up";
    right = "Right";
  };
in
{
  options = {
    i3AddKeybinds =  with lib; mkOption {
      type = with types; attrsOf str;
      description = "Additional keybindings to the default ones.";
      default = { };
    };
    i3AddNamedKeybinds = with lib; mkOption {
      type = with types; attrsOf (attrsOf str);
      description = "Additional keybindings to the default ones.
        The keybinds are collected in a set whose names are discarded,
        and so can be used for organization purpose.";
      default = { };
      apply = x: (lib.concatMapAttrs (name: value: value) x) // config.i3AddKeybinds;
    };
  };
  imports = [
    ./polybar.nix
    (inputs.feh-random-background + /home-manager-service.nix)
  ];

  config = {
    xsession = {
      enable = true; # .xsession for lightDM
      windowManager.i3 = {
        enable = true;
        package = pkgs.unstable.i3; # TODO stable after gaps being merged
        config = {
          modifier = "Mod4";
          terminal = "kitty";
          menu = "rofi -show drun";
          defaultWorkspace = "workspace number 1";
          floating.criteria =[
            { class = "firefox"; title = "^Developer Tools [-—]"; }
            { class = "file-roller"; title = "Extract"; }
            { class = "file-roller"; title = "Compress"; }
            { class = "nemo"; title = "Properties"; }
            { class = "Pavucontrol"; }
            { class = "qalculate-gtk"; }
            { class = "copyq"; }
          ];
          window.commands = [
            { criteria = { class = "firefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
            { criteria = { class = "firefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
          ];
          gaps.inner = 5;
          # TODO transaprent not working in i3
          colors.unfocused = let transparent = "#00000000"; in {
            background = "#222222";
            border = transparent;
            childBorder = transparent;
            indicator = "#292d2e";
            text = "#888888";
          };
          gaps.smartBorders = "on";
          window.titlebar = false;
          floating.titlebar = false;
          startup = [
            {
              command = "${pkgs.copyq}/bin/copyq";
              notification = false;
            }
          ];
          keybindings = lib.mkOptionDefault config.i3AddNamedKeybinds;
        };
      };
    };

    services.picom.enable = true;
    programs.rofi = {
      enable = true;
      terminal = config.xsession.windowManager.i3.config.terminal;
      extraConfig = {
        show-icons = true;
      };
      # TODO config
    };
    i3AddKeybinds."${modifier}+Shift+e" = let
      rofi-exit = pkgs.writeShellScript "rofi-exit.sh"  ''
        case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | rofi -dmenu -p "Logout menu") in
          "Shutdown") systemctl poweroff;;
          "Suspend") systemctl suspend;;
          "Reboot") systemctl reboot;;
          "Logout") i3-msg exit;;
        esac
      '';
    in
    "exec ${rofi-exit}";
    services.dunst = {
      enable = true;
      # TODO config
    };
    i3AddKeybinds = {
      "XF86AudioRaiseVolume" = "exec --no-startup-id pamixer --unmute --increase 5";
      "XF86AudioLowerVolume" = "exec --no-startup-id pamixer --decrease 5";
      "XF86AudioMute" = "exec --no-startup-id pamixer -t";
    };
    i3AddKeybinds = {
      "XF86MonBrightnessDown" = "exec --no-startup-id light -U 2";
      "XF86MonBrightnessUp" = "exec --no-startup-id light -A 2";
    };
    services.gammastep = {
      enable = true;
      latitude = 46.; # North
      longitude = 13.; # East
      tray = false;
    };
    i3AddNamedKeybinds.moveToScreen = with lib; listToAttrs (concatMap
      (mapAttrsToList (name: value: nameValuePair "${modifier}+Ctrl+Shift+${value}" "move workspace to output ${name}"))
      [
        vi-directions
        arrow-directions
      ]
    );
    i3AddNamedKeybinds.move = with lib; listToAttrs (concatLists (concatMap
      (mapAttrsToList
        (name: value: [
          (nameValuePair "${modifier}+${value}" "focus ${name}")
          (nameValuePair "${modifier}+Shift+${value}" "move ${name}")
        ])
      )
      [
        vi-directions
        arrow-directions
      ]
    ));
    i3AddNamedKeybinds.additionalWS = with lib; listToAttrs (concatMap
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
    i3AddKeybinds."Ctrl+${alt}+l" = ''exec --no-startup-id "i3lock-color --clock --indicator --blur 7x5 --pass-{media,screen,power,volume}-keys"'';
    i3AddNamedKeybinds.shortcuts = {
      "${modifier}+z" = "exec firefox";
      "${modifier}+x" = "exec nemo";
      "${modifier}+v" = "exec ${config.xsession.windowManager.i3.config.terminal} nvim";
    };
    i3AddKeybinds."${modifier}+q" = "exec copyq toggle";
    services.feh-random-background = {
      enable = true;
      imageDirectory = "${inputs.wallpapers}";
      interval = "1m";
    };

    home.packages = with pkgs; [
      i3lock-color
      copyq
      xclip
      polkit_gnome
    ];
  };
}

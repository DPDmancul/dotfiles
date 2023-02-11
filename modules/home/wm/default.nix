{ config, pkgs, lib, ... }:
let
  common-options = wm: lib.mkMerge [
    {
      config.keybindings = lib.mkOptionDefault
        (lib.mapAttrs' (name: value: lib.nameValuePair (if wm == "i3" then lib.removePrefix "--locked " name else name) (value."${wm}" or value))
          (lib.filterAttrs (name: value: builtins.isString value || value ? "${wm}") config.sway-i3AddNamedKeybinds));
      config.modifier = "Mod4";
      config.terminal = "kitty";
      config.menu = ''rofi -show drun'';
      config.defaultWorkspace = "workspace number 1";
      config.floating.criteria = let
        class = if wm == "sway" then "app_id" else "class";
      in
      [
        { ${class} = "firefox"; title = "^Developer Tools [-—]"; }
        { ${class} = "file-roller"; title = "Extract"; }
        { ${class} = "file-roller"; title = "Compress"; }
        { ${class} = "nemo"; title = "Properties"; }
        { ${class} = "pavucontrol"; }
        { ${class} = "qalculate-gtk"; }
        { ${class} = "copyq"; }
      ];
      config.window.commands = let
        class = if wm == "sway" then "app_id" else "class";
      in
      [
        { criteria = { ${class} = "firefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
        { criteria = { ${class} = "firefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
        # { criteria = { shell = "xwayland"; }; command = ''title_format "%title [%shell]"''; } # TODO: does not work for waybar
      ];
      config.gaps.inner = 5;
      # TODO transaprent not working in i3
      config.colors.unfocused = let transparent = "#00000000"; in {
        background = "#222222";
        border = transparent;
        childBorder = transparent;
        indicator = "#292d2e";
        text = "#888888";
      };
      config.gaps.smartBorders = "on";
      config.window.titlebar = false;
      extraConfig = ''
        exec ${pkgs.copyq}/bin/copyq
      '';
    }
  ];
  inherit (config.wayland.windowManager.sway.config) modifier left down up right;
in
{
  options = {
    sway-i3AddKeybinds =  with lib; mkOption {
      type = with types; attrsOf (oneOf [ str (attrsOf str) ]);
      description = "Additional keybindings to the default ones.
        You can optionally specify different execs for each wm.";
      default = { };
    };
    sway-i3AddNamedKeybinds = with lib; mkOption {
      type = with types; attrsOf (attrsOf (oneOf [ str (attrsOf str) ]));
      description = "Additional keybindings to the default ones.
        You can optionally specify different execs for each wm.
        The keybinds are collected in a set whose names are discarded,
        and so can be used for organization purpose.";
      default = { };
      apply = x: (lib.concatMapAttrs (name: value: value) x) // config.sway-i3AddKeybinds;
    };
  };
  config = {
    wayland.windowManager.sway = common-options "sway";
    xsession.windowManager.i3 = common-options "i3";

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = {
        show-icons = true;
      };
      # TODO config
    };
    sway-i3AddKeybinds."${modifier}+Shift+e" = let
      rofi-exit = logout: pkgs.writeShellScript "rofi-exit.sh"  ''
        case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | rofi -dmenu -p "Logout menu") in
          "Shutdown") systemctl poweroff;;
          "Suspend") systemctl suspend;;
          "Reboot") systemctl reboot;;
          "Logout") ${logout};;
        esac
      '';
    in
    {
      sway = "exec ${rofi-exit "swaymsg exit"}";
      i3 = "exec ${rofi-exit "i3-msg exit"}";
    };
    services.dunst = {
      enable = true;
      # TODO config
    };
    sway-i3AddKeybinds = {
      "--locked XF86AudioRaiseVolume" = "exec pamixer -u -i 5";
      "--locked XF86AudioLowerVolume" = "exec pamixer -d 5";
      "--locked XF86AudioMute" = "exec pamixer -t";
    };
    sway-i3AddKeybinds = {
      "--locked XF86MonBrightnessDown" = "exec light -U 2";
      "--locked XF86MonBrightnessUp" = "exec light -A 2";
    };
    services.gammastep = {
      enable = true;
      latitude = 46.; # North
      longitude = 13.; # East
      tray = false;
    };
    sway-i3AddNamedKeybinds.moveToScreen = with lib; listToAttrs (concatMap
      (mapAttrsToList (name: value: nameValuePair "${modifier}+Ctrl+Shift+${value}" "move workspace to output ${name}"))
      [
        { inherit left down up right; }
        { left = "Left"; down = "Down"; up = "Up"; right = "Right"; }
      ]
    );
    sway-i3AddNamedKeybinds.move = with lib; listToAttrs (concatLists (concatMap
      (mapAttrsToList
        (name: value: [
          (nameValuePair "${modifier}+${value}" "focus ${name}")
          (nameValuePair "${modifier}+Shift+${value}" "move ${name}")
        ])
      )
      [
        { inherit left down up right; }
        { left = "Left"; down = "Down"; up = "Up"; right = "Right"; }
      ]
    ));
    sway-i3AddNamedKeybinds.additionalWS = with lib; listToAttrs (concatMap
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
    sway-i3AddNamedKeybinds.shortcuts = {
      "${modifier}+z" = "exec firefox";
      "${modifier}+x" = "exec nemo";
      "${modifier}+v" = "exec kitty nvim";
    };
    sway-i3AddKeybinds."${modifier}+q" = "exec copyq toggle";

    home.packages = with pkgs; [
      copyq
      polkit_gnome
    ];
  };
}

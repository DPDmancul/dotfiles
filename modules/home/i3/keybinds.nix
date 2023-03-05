{ config, pkgs, lib, inputs, ... }:
let
  inherit (config.xsession.windowManager.i3.config) modifier;
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
  config = {
    xsession.windowManager.i3.config = {
      modes.resize = {
        Escape = "mode default";
        Return = "mode default";
      } // lib.concatMapToAttrs
        ({left, down, up, right}: {
          ${left} = "resize shrink width 10 px";
          ${right} = "resize grow width 10 px";
          ${down} = "resize shrink height 10 px";
          ${up} = "resize grow height 10 px";
        })
        [
          vi-directions
          arrow-directions
        ];
      defaultWorkspace = "workspace number 1";
      keybindings = lib.mkOptionDefault config.i3AddNamedKeybinds;
    };

    i3AddNamedKeybinds.move = lib.concatMapPairToAttrs
      (name: value: {
        "${modifier}+${value}" = "focus ${name}";
        "${modifier}+Shift+${value}" = "move ${name}";
      })
      [
        vi-directions
        arrow-directions
      ];
    i3AddNamedKeybinds.moveToScreen = lib.concatMapPairToAttrs
      (name: value: {
        "${modifier}+Ctrl+Shift+${value}" = "move workspace to output ${name}";
      })
      [
        vi-directions
        arrow-directions
      ];
    i3AddKeybinds = {
      "${modifier}+Shift+h" = "split h";
      "${modifier}+Shift+v" = "split v";
    };
    i3AddKeybinds = {
      "${modifier}+Shift+s" = "sticky toggle";
    };
    i3AddNamedKeybinds.additionalWS = with lib; concatMapAttrs
      (name: value:
        let
          ws = toString value;
        in
        {
          "${modifier}+${name}" = "workspace number ${ws}";
          "${modifier}+Shift+${name}" = "move container to workspace number ${ws}";
          "${modifier}+Ctrl+${name}" = "move container to workspace number ${ws}, workspace number ${ws}";
        })
      ({
        "grave" = 0;
        "Escape" = 10;
      } // (concatMapToAttrs
        (n: { ${toString n} = n; })
        [ 1 2 3 4 5 6 7 8 9 ])
      // concatMapToAttrs
        (n: { "F${toString n}" = (10 + n); })
        [ 1 2 3 4 5 6 7 8 9 10 11 12 ]
      );
    i3AddNamedKeybinds.shortcuts = {
      "${modifier}+z" = "exec firefox";
      "${modifier}+x" = "exec nemo";
      "${modifier}+v" = "exec ${config.xsession.windowManager.i3.config.terminal} nvim";
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
  };
}

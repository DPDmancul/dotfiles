{ config, pkgs, lib, ... }:
let
  fuzzel-exit = pkgs.writeShellScript "fuzzel-exit.sh"  ''
    case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | fuzzel --dmenu -p "Logout menu") in
      "Shutdown") systemctl poweroff;;
      "Suspend") systemctl suspend;;
      "Reboot") systemctl reboot;;
      "Logout") loginctl kill-user $(whoami);;
    esac
  '';
in
{
  xdg.configFile."niri/config.kdl".text = ''
    binds {
      // Mod-?
      Mod+Shift+Slash { show-hotkey-overlay; }

      Mod+Shift+Q repeat=false { close-window; }

      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Mod+Left  { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H     { focus-column-left; }
      Mod+J     { focus-window-down; }
      Mod+K     { focus-window-up; }
      Mod+L     { focus-column-right; }

      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }

      Mod+O repeat=false { toggle-overview; }
      Mod+Ctrl+Left  { move-column-left; }
      Mod+Ctrl+Down  { move-window-down; }
      Mod+Ctrl+Up    { move-window-up; }
      Mod+Ctrl+Right { move-column-right; }
      Mod+Ctrl+H     { move-column-left; }
      Mod+Ctrl+J     { move-window-down; }
      Mod+Ctrl+K     { move-window-up; }
      Mod+Ctrl+L     { move-column-right; }

      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }

      Mod+BracketLeft  { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+Comma  { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }
      Mod+Shift+Left  { focus-monitor-left; }
      Mod+Shift+Down  { focus-monitor-down; }
      Mod+Shift+Up    { focus-monitor-up; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+H     { focus-monitor-left; }
      Mod+Shift+J     { focus-monitor-down; }
      Mod+Shift+K     { focus-monitor-up; }
      Mod+Shift+L     { focus-monitor-right; }
      Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
      Mod+Page_Down      { focus-workspace-down; }
      Mod+Page_Up        { focus-workspace-up; }
      Mod+U              { focus-workspace-down; }
      Mod+I              { focus-workspace-up; }

      Mod+Tab { focus-workspace-previous; }
      Mod+Shift+Page_Down { move-workspace-down; }
      Mod+Shift+Page_Up   { move-workspace-up; }
      Mod+Shift+U         { move-workspace-down; }
      Mod+Shift+I         { move-workspace-up; }
      Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
      Mod+Ctrl+U         { move-column-to-workspace-down; }
      Mod+Ctrl+I         { move-column-to-workspace-up; }
      Mod+R { switch-preset-column-width; }
      Mod+Ctrl+R { reset-window-height; }
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+Ctrl+F { expand-column-to-available-width; }

      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+C { center-column; }
      Mod+Ctrl+C { center-visible-columns; }

      Mod+V       { toggle-window-floating; }
      Mod+Shift+V { switch-focus-between-floating-and-tiling; }

      Mod+W { toggle-column-tabbed-display; }
      Mod+T hotkey-overlay-title="Open a Terminal: kitty" { spawn "kitty"; }
      Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }
      Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }

      Mod+Z hotkey-overlay-title="Open a Browser: firefox" { spawn "firefox"; }
      Mod+X hotkey-overlay-title="Open a File Manager: nemo" { spawn "nemo"; }

      Mod+Q hotkey-overlay-title="Open a Clipboard Manager: copyq" { spawn "copyq" "toggle"; }

      Print { screenshot; }
      Ctrl+Print { screenshot-screen write-to-disk=false; }
      Alt+Print { screenshot-window write-to-disk=false; }
      Ctrl+Shift+Print { screenshot-screen; }
      Alt+Shift+Print { screenshot-window; }
      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" "-l" "1.0"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
      XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute allow-when-locked=true { spawn "wpctl" "set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
      XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
      XF86AudioStop allow-when-locked=true { spawn "playerctl" "stop"; }
      XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
      XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
      XF86MonBrightnessUp allow-when-locked=true { spawn "light" "-A" "2"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "light" "-U" "2"; }

      Mod+Shift+P { power-off-monitors; }
      Mod+Shift+E { spawn "${fuzzel-exit}"; }
      Ctrl+Alt+Delete { spawn "${fuzzel-exit}"; }
    }
  '';
}

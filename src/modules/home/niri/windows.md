# Niri windows

```nix modules/home/niri/windows.nix
{ config, pkgs, lib, ... }:
{
  xdg.configFile."niri/config.kdl".text = ''
    <<<modules/home/niri/windows-config>>>
  '';
}
```

## Layout

```kdl "modules/home/niri/windows-config" +=
layout {
  gaps 5

  // make gaps inner only
  struts {
    left -5
    right -5
    top -5
    bottom -5
  }

  preset-column-widths {
    proportion 0.33333
    proportion 0.5
    proportion 0.66667
  }

  default-column-width { proportion 1.0; }

  focus-ring {
    width 2
    active-color "#fad57f"
  }

  border {
    off
  }

  shadow {
    on
  }
}

window-rule {
  geometry-corner-radius 8
  clip-to-geometry true
}

hotkey-overlay {
  skip-at-startup
}

prefer-no-csd
```

## Window rules

```kdl "modules/home/niri/windows-config" +=
window-rule {
  match app-id=r#"firefox$"# title=r#"^Picture-in-Picture$"#
  open-floating true
  // TODO: sticky enable, border none, inhibit_idle open
}

window-rule {
  match app-id=r#"firefox$"# title=r#"[Ss]haring (Indicator|your screen)$"#
  open-floating true
  // TODO: move to scratchpad
}

window-rule {
  match app-id=r#"firefox$"# title=r#"^Developer Tools [-—]"#
  open-floating true
}

window-rule {
  match app-id=r#"^file-roller$"# title=r#"Extract|Compress"#
  open-floating true
}

window-rule {
  match title=r#"file Transfer.*"#
  open-floating true
}

window-rule {
  match app-id=r#"^nemo$"# title=r#"Properties"#
  open-floating true
}

window-rule {
  match app-id=r#"^pavucontrol$"#
  open-floating true
}

window-rule {
  match app-id=r#"^qalculate-gtk$"#
  open-floating true
}

window-rule {
  match app-id=r#"^copyq$"#
  open-floating true
}

window-rule {
  match title=r#"MuseScore: Play Panel"#
  open-floating true
}
```

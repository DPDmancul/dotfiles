# Kitty

```nix "home-config" +=
programs.kitty = {
  enable = true;
  <<<kitty-config>>>
  settings = {
    <<<kitty-settings>>>
  };
};
```

## Appearance

### Font

```nix "kitty-config" +=
font = {
  name = "firacode nerd font";
  size = 10;
};
```

Do not use curly style for urls

```nix "kitty-settings" +=
url_style = "single";
```

### Colors

Gruvbox light

```nix "kitty-settings" +=
cursor                  = "#928374";
background              = "#fbf1c7";
foreground              = "#282828";
selection_foreground    = "#665c54";
selection_background    = "#d5c4a1";
# white
color0                  = "#fbf1c7";
color8                  = "#9d8374";
# red
color1                  = "#cc241d";
color9                  = "#9d0006";
# green
color2                  = "#98971a";
color10                 = "#79740e";
# yellow
color3                  = "#d79921";
color11                 = "#b57614";
# blue
color4                  = "#458588";
color12                 = "#076678";
# purple
color5                  = "#b16286";
color13                 = "#8f3f71";
# aqua
color6                  = "#689d6a";
color14                 = "#427b58";
# black
color7                  = "#7c6f64";
color15                 = "#3c3836";
```

#### Tabs

```nix "kitty-settings" +=
active_tab_background   = "#fbf1c7";
inactive_tab_background = "#d5c4a1";
tab_bar_background      = "none";

```

#### Title bar

Automatically match title bar color on Wayland

```nix "kitty-settings" +=
wayland_titlebar_color = "background";
```

### Tabs style

```nix "kitty-settings" +=
tab_bar_edge        = "top";
tab_bar_style       = "powerline";
tab_powerline_style = "slanted";
```


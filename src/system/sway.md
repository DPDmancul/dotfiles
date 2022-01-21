# Sway

Use Sway as window manager

```nix "config" +=
programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  extraPackages = with pkgs; [
    <<<sway-packages>>>
  ];
};
```

```nix "env" +=
XDG_CURRENT_DESKTOP = "sway";
```

## Waybar

Use waybar instead of swaybar

```nix "sway-packages" +=
waybar
```

```nix "config" +=
programs.waybar.enable = true;
```

## Applications runner

```nix "sway-packages" +=
wofi
```

## Lockscreen

```nix "sway-packages" +=
swaylock
swayidle
```

## Clipboard

```nix "sway-packages" +=
wl-clipboard
```

Add clipboard support to X11 programs

```nix "config" +=
nixpkgs.overlays = [
  (self: super: {
    wl-clipboard-x11 = super.stdenv.mkDerivation rec {
    pname = "wl-clipboard-x11";
    version = "5";

    src = super.fetchFromGitHub {
      owner = "brunelli";
      repo = "wl-clipboard-x11";
      rev = "v${version}";
      sha256 = "1y7jv7rps0sdzmm859wn2l8q4pg2x35smcrm7mbfxn5vrga0bslb";
    };

    dontBuild = true;
    dontConfigure = true;
    propagatedBuildInputs = [ super.wl-clipboard ];
    makeFlags = [ "PREFIX=$(out)" ];
    };

    xsel = self.wl-clipboard-x11;
    xclip = self.wl-clipboard-x11;
  })
];
```

## Notifications

```nix "sway-packages" +=
mako
```
## Screen

### Automatic randr

```nix "sway-packages" +=
autorandr
```

### Brightness

```nix "config" +=
programs.light.enable = true;
```

### Screen capturing

#### Screen sharing

```nix "config" +=
xdg.portal.wlr.enable = true;
```

## X compatibility

```nix "sway-packages" +=
xwayland
```

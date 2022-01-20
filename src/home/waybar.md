# Waybar

```nix "sway-config" +=
bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
```

```nix "home-config" +=
programs.waybar = {
  enable = true;
  # settings = {};
};
```

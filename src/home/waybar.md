# Waybar

Manage waybar via systemd

```nix "sway-config" +=
bars = [];
```

```nix "home-config" +=
programs.waybar = {
  enable = true;
  systemd.enable = true;
  # settings = {};
};
```

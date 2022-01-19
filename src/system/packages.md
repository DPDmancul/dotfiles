# Packages

```nix "config" +=
environment.systemPackages = with pkgs; [
  <<<packages>>>
];
```

Run the rolling release version of Nix

```nix "config" +=
system.autoUpgrade.channel = "github:nixos/nixpkgs/nixos-unstable";
```

## Essentials

### Text editor

```nix "packages" +=
neovim
```

Set as default

```nix "env" +=
EDITOR = "nvim";
VISUAL = "nvim";
```

### Terminal and shell

Use kitty as terminal

```nix "packages" +=
kitty
```

Use fish as default shell

```nix "config" +=
programs.fish.enable = true;
users.defaultUserShell = pkgs.fish;
```

### Internet

```nix "packages" +=
wget
firefox-wayland
```

Force Firefox to use wayland

```nix "env" +=
MOZ_ENABLE_WAYLAND = "1";
```

## Settings

### Audio

```nix "packages" +=
pavucontrol
```



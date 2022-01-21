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

Use kitty as terminal with starship as prompt

```nix "packages" +=
kitty
starship
```

Use fish as default shell

```nix "config" +=
programs.fish.enable = true;
users.defaultUserShell = pkgs.fish;
```

#### Task manager

```nix "packages" +=
bottom
```

#### Rust tools

Use Rust modern tools.

Taken from: <https://www.mahmoudashraf.dev/blog/my-terminal-became-more-rusty/>

Bat is an implementation for cat command but with syntax highlighted.

Exa is an implementation of ls command but with colors and icons and it renders very fast.

```nix "packages" +=
bat
exa
```

### Internet

```nix "packages" +=
wget
firefox-wayland
tor-browser-bundle-bin
```

Force Firefox to use wayland

```nix "env" +=
MOZ_ENABLE_WAYLAND = "1";
```

### File manager

```nix "packages" +=
xfce.thunar
udiskie
```

## Build utils

### Utilities

```nix "packages" +=
git
gnumake
```

### Compilers

```nix "packages" +=
gcc
```

## Settings

```nix "packages" +=
pavucontrol # audio
blueman # bluetooth
```

## Viewers

```nix "packages" +=
imv # images
libsForQt5.okular # PDF
vlc # multimedia
```


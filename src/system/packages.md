# Packages

```nix "config" +=
environment.systemPackages = with pkgs; [
  <<<packages>>>
];
```

Run the rolling release version of Nix

TODO: migrate to flakes.

```sh
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
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

#### Utilities

```nix "packages" +=
bat      # cat with syntax highlighting
exa      # ls with colors and icosn
tldr     # short command examples
fd       # faster find
ripgrep  # alternative grep
usbutils
pciutils
```

### xdg utils

```nix "packages" +=
xdg-utils
```

### Internet

```nix "packages" +=
wget
firefox-wayland
(tor-browser-bundle-bin.override {
  useHardenedMalloc = false;
})
```

Force Firefox to use wayland

```nix "env" +=
MOZ_ENABLE_WAYLAND = "1";
```

### File manager

```nix "packages" +=
pcmanfm
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
blueman     # bluetooth
wdisplays   # screen
```

## Viewers

```nix "packages" +=
imv               # images
libsForQt5.okular # PDF
mpv               # video
lollypop          # audio
```


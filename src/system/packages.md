# Packages

```nix "config" +=
environment.systemPackages = with pkgs; [
  <<<packages>>>
];
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

### Shell

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


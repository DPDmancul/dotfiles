# Packages

```nix modules/system/packages.nix
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    <<<modules/system/packages-packages>>>
  ];
  <<<modules/system/packages>>>
}
```

## Essentials

### Text editor

```nix "modules/system/packages-packages" +=
neovim
```

Set as default

```nix "modules/system/packages" +=
environment.sessionVariables = {
  EDITOR = "nvim";
  VISUAL = "nvim";
};
```

### Shell

Use fish as default shell

```nix "modules/system/packages" +=
programs.fish.enable = true;
users.defaultUserShell = pkgs.fish;
```

#### Task manager

```nix "modules/system/packages-packages" +=
bottom
```

#### Utilities

```nix "modules/system/packages-packages" +=
bat      # cat with syntax highlighting
lsd      # ls with colors and icons (TODO config)
tldr     # short command examples
fd       # faster find
ripgrep  # alternative grep
usbutils
pciutils
sops
```

### xdg utils

```nix "modules/system/packages-packages" +=
xdg-utils
```

### Internet

```nix "modules/system/packages-packages" +=
wget
```
## Build utils

### Utilities

```nix "modules/system/packages-packages" +=
git
gnumake
```

### Compilers

```nix "modules/system/packages-packages" +=
gcc
```


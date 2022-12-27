# Home

Here is collected the common config for all users.

In this folder there are also some useful modules used only by some user configs.

```nix modules/home/default.nix
{ config, pkgs, lib, user, dotfiles, assets, ... }:
{
  imports = [
    ./kitty.nix
    ./fish.nix
    ./nvim
    ./sway
    ./firefox.nix
    ./xdg.nix
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./packages
  ];

  <<<modules/home>>>
}
```

## Home directory

```nix "modules/home" +=
home.username = user;
home.homeDirectory = "/home/${config.home.username}";
```

## Dots utility

Quickly apply dotfiles

```nix "modules/home" +=
home.packages = [
  (pkgs.writeShellScriptBin "dots" ''
    cd "${dotfiles}"
    nix-shell --run "make $*"
  '')
];
```

## State version

**DO NOT TOUCH!**

```nix "modules/home" +=
home.stateVersion = "22.05";
```

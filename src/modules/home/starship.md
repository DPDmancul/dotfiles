# Starship

Use starship to manage the prompt

```nix modules/home/starship.nix
{ config, pkgs, lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      <<<modules/home/starship-config>>>
    };
  };
}
```

## Prompt format

```nix "modules/home/starship-config" +=
format = "╭─$all╰─$jobs$character";
right_format = "$status";
```

## Directory

Replace `~` with an emoji.

```nix "modules/home/starship-config" +=
directory.home_symbol = "🏠"; # Nerd font variant: 
```

## Show status

Display status of previous failed command with a symbol and a small description

```nix "modules/home/starship-config" +=
status = {
  disabled = false;
  map_symbol = true;
};
```


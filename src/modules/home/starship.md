# Starship

Use starship to manage the prompt

```nix modules/home/starship.nix
{ config, pkgs, lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      <<<modules/home/starship>>>
    };
  };
}
```

## Prompt format

```nix "modules/home/starship" +=
format = "╭─$all╰─$jobs$character";
right_format = "$status";
```

## Directory

Replace `~` with an emoji.

```nix "modules/home/starship" +=
directory.home_symbol = "🏠"; # Nerd font variant: 
```

## Show status

Display status of previous failed command with a symbol and a small description

```nix "modules/home/starship" +=
status = {
  disabled = false;
  map_symbol = true;
};
```


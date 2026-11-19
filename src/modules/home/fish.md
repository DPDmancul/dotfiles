# Fish

```nix modules/home/fish.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./starship.nix
  ];

  programs.fish = {
    enable = true;
    plugins = [
      <<<modules/home/fish-plugins>>>
    ];
    interactiveShellInit = ''
      <<<modules/home/fish-init>>>
    '';
    <<<modules/home/fish-config>>>
  };
}
```

## Vi mode

Use the same movements of vi, vim and neovim

```fish "modules/home/fish-init" +=
fish_vi_key_bindings
```

Change the cursor based on the mode

```fish "modules/home/fish-init" +=
set fish_cursor_default block blink
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore blink
```

## Plugins

### Color theme

Use JB light syntax colors.

```fish "modules/home/fish-init" +=
set -g fish_color_normal 080808
set -g fish_color_command 00627A
set -g fish_color_keyword 0033B3
set -g fish_color_param 000000
set -g fish_color_option 871094
set -g fish_color_quote 067D17
set -g fish_color_escape 0037A6
set -g fish_color_redirection 080808
set -g fish_color_end 080808
set -g fish_color_operator 080808
set -g fish_color_comment 8C8C8C --italics
set -g fish_color_error F50000
set -g fish_color_autosuggestion 8C8C8C
set -g fish_color_valid_path --underline
set -g fish_color_search_match --background=EDF3FF
set -g fish_color_selection --background=EDF3FF
set -g fish_pager_color_prefix 0033B3 --bold
set -g fish_pager_color_completion 000000
set -g fish_pager_color_description 8C8C8C
set -g fish_pager_color_progress 6C707E
```

#### Colored manpages

```nix "modules/home/fish-plugins" +=
{
  name = "fish-colored-man";
  src = pkgs.fetchFromGitHub {
    owner = "decors";
    repo = "fish-colored-man";
    rev = "1ad8fff";
    sha256 = "uoZ4eSFbZlsRfISIkJQp24qPUNqxeD0JbRb/gVdRYlA=";
  };
}
```

Color scheme

```fish "modules/home/fish-init" +=
set -g man_blink -o red
set -g man_bold -o green
set -g man_standout -b cyan black
set -g man_underline -o yellow
```

## Aliases

```nix "modules/home/fish-config" +=
shellAliases = {
  df = "df -h"; # Human-readable sizes
  free = "free -h"; # Human-readable sizes
  gitu = "git add . && git commit && git push";
  nv = "nvim";
  mk = "make";
  lg = "lazygit";
  nix-fish = "nix-shell --run fish";
  mkcd = ''mkdir -p "$argv"; and cd'';
  # cat = "bat";
  dc = "docker-compose";
};
```

## Prompt

### Welcome prompot

Print a greeting message when shell is started, reporting 

- User and hostname
- Kernel version
- OS and distribution

```fish "modules/home/fish-init" +=
set DISTRIBUTION (cat /etc/os-release | grep PRETTY | sed 's/PRETTY_NAME="\(.*\)"/\1/')
set fish_greeting  (set_color green)$USER@(uname -n) (set_color yellow)(uname -srm) (set_color cyan)(uname -o) $DISTRIBUTION
```


# Fish

```nix modules/home/fish.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./starship.nix
    ./zoxide.nix
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

```nix "modules/home/fish-plugins" +=
{
  name = "base16-fish";
  src = pkgs.fetchFromGitHub {
    owner = "tomyun";
    repo = "base16-fish";
    rev = "2f6dd97";
    sha256 = "PebymhVYbL8trDVVXxCvZgc0S5VxI7I1Hv4RMSquTpA=";
  };
}
```

Use Gruvbox Light theme

```fish "modules/home/fish-init" +=
base16-gruvbox-light-medium
set -x BAT_THEME gruvbox-light
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
  free = "free -m"; # Show sizes in MB
  gitu = "git add . && git commit && git push";
  nv = "nvim";
  mk = "make";
  lg = "lazygit";
  nix-fish = "nix-shell --run fish";
  mkcd = ''mkdir -p "$argv"; and cd'';
  # cat = "bat";
  ll = "lsd -l";
};
```

Use the ssh wrapper of kitty when using kitty terminal

```fish "modules/home/fish-init" +=
if test $TERM = 'xterm-kitty'
  alias ssh 'kitty +kitten ssh'
end
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


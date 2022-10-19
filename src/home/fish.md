# Fish

```nix "home-config" +=
programs.fish = {
  enable = true;
  plugins = [
    <<<fish-plugins>>>
  ];
  interactiveShellInit = ''
    <<<fish-init>>>
  '';
};
```

## Vi mode

Use the same movements of vi, vim and neovim

```fish "fish-init" +=
fish_vi_key_bindings
```

Change the cursor based on the mode

```fish "fish-init" +=
set fish_cursor_default block blink
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore blink
```

## Plugins

### Color theme

```nix "fish-plugins" +=
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

```fish "fish-init" +=
base16-gruvbox-light-medium
set -x BAT_THEME gruvbox-light
```

#### Colored manpages

```nix "fish-plugins" +=
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

```fish "fish-init" +=
set -g man_blink -o red
set -g man_bold -o green
set -g man_standout -b cyan black
set -g man_underline -o yellow
```

## Aliases

```nix "home-config" +=
programs.fish.shellAliases = {
# environment.shellAliases = {
  df = "df -h"; # Human-readable sizes
  free = "free -m"; # Show sizes in MB
  gitu = "git add . && git commit && git push";
  nv = "nvim";
  mk = "make";
  lg = "lazygit";
  nix-fish = "nix-shell --run fish";
  mkcd = ''mkdir -p "$argv"; and cd'';
  # cat = "bat";
  exa = "exa -G --color auto --icons -a -s type";
  ll = "exa -l --color always --icons -a -s type";
};
```

Use the ssh wrapper of kitty when using kitty terminal

```fish "fish-init" +=
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

```fish "fish-init" +=
set DISTRIBUTION (cat /etc/os-release | grep PRETTY | sed 's/PRETTY_NAME="\(.*\)"/\1/')
set fish_greeting  (set_color green)$USER@(uname -n) (set_color yellow)(uname -srm) (set_color cyan)(uname -o) $DISTRIBUTION
```

### Starship

Use starship to manage the prompt

```nix "home-config" +=
programs.starship = {
  enable = true;
  settings = {
    <<<starship-config>>>
  };
};
```

#### Configuration

##### Prompt format

```nix "starship-config" +=
format = "╭─$all╰─$jobs$character";
right_format = "$status";
```

##### Directory

Replace `~` with an emoji.

```nix "starship-config" +=
directory.home_symbol = "🏠"; # Nerd font variant: 
```

##### Show status

Display status of previous failed command with a symbol and a small description

```nix "starship-config" +=
status = {
  disabled = false;
  map_symbol = true;
};
```


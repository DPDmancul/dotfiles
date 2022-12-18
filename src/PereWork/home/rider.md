# JetBrains Rider

```nix PereWork/home/rider.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    unfree.jetbrains.rider
  ];

  <<<PereWork/home/rider>>>
}
```

## Vim emulation

```nix "PereWork/home/rider" +=
xdg.configFile."ideavim/ideavimrc".text = ''
  <<<PereWork/home/rider-ideavimrc>>>
'';
```

Source vim config

```vim "PereWork/home/rider-ideavimrc" +=
source ~/.config/nvim/init-home-manager.vim
```

### Settings

```vim "PereWork/home/rider-ideavimrc" +=
set ideajoin # `J` to join lines
set ideaput  # clipboard integration
```

### Plugins

```vim "PereWork/home/rider-ideavimrc" +=
set commentary
set surround
```

Use sandwich key mapping for surround

```vim "PereWork/home/rider-ideavimrc" +=
map sa ys
map sr cs
map sd ds
```

### Mappings

TODO

```vim "PereWork/home/rider-ideavimrc" +=
map <leader>ff <Action>(GotoFile)
map <leader>fg <Action>(FindInPath)
map <leader>fb <Action>(Switcher)
" map <leader>fp <Action>() TODO
map <leader>gg <Action>(GitRepositoryActions) " TODO

map ]b <Action>(NextTab)
" map ]B <Action>() TODO 
map [b <Action>(PreviousTab)
" map [B <Action>() TODO

map gD <Action>(GotoDeclaration)
map gI <Action>(GotoImplementation)
map <leader>e <Action>(ShowErrorDescription)
map <leader>cf <Action>(ReformatCode)

map <C-\> <Action>(ActivateTerminalToolWindow)
```



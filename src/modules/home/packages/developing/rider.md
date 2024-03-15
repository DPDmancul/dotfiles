# JetBrains Rider

```nix modules/home/packages/developing/rider.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    mono
    unfree.unstable.jetbrains.rider
    unfree.codeium # TODO: symlink
  ];

  <<<modules/home/packages/developing/rider>>>
}
```

Remember to set the correct path for the dotnet cli: set `~/.nix-profile/dotnet`
in `Settings` → `Build, Execution, Deployment` → `Toolset and Build` → `.NET
CLI executable path`

## Vim emulation

```nix "modules/home/packages/developing/rider" +=
xdg.configFile."ideavim/ideavimrc".text = ''
  <<<modules/home/packages/developing/rider-ideavimrc>>>
'';
```

Source vim config

```vim "modules/home/packages/developing/rider-ideavimrc" +=
${config.programs.neovim.generatedConfigViml}
```

### Settings

```vim "modules/home/packages/developing/rider-ideavimrc" +=
set ideajoin # `J` to join lines
set clipboard+=ideaput # clipboard integration
set showmode
```

### Plugins

```vim "modules/home/packages/developing/rider-ideavimrc" +=
set commentary
set surround
```

Use sandwich key mapping for surround

```vim "modules/home/packages/developing/rider-ideavimrc" +=
map sa ys
map sr cs
map sd ds
```

### Mappings

TODO

```vim "modules/home/packages/developing/rider-ideavimrc" +=
map <leader>ff <Action>(GotoFile)
map <leader>fg <Action>(FindInPath)
map <leader>fb <Action>(Switcher)
" map <leader>fp <Action>() TODO
map <leader>gg <Action>(ActivateVersionControlToolWindow)

map ]b <Action>(NextTab)
" map ]B <Action>() TODO 
map [b <Action>(PreviousTab)
" map [B <Action>() TODO

map ]d <Action>(GotoNextError) 
map [d <Action>(GotoPreviousError)

map gD <Action>(GotoDeclaration)
map gI <Action>(GotoImplementation)
map <leader>e <Action>(ShowErrorDescription)
map <leader>cf <Action>(ReformatCode)

map <C-\> <Action>(ActivateTerminalToolWindow)
```



{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    unfree.jetbrains.rider
  ];

  xdg.configFile."ideavim/ideavimrc".text = ''
    ${config.programs.neovim.generatedConfigViml}
    vnoremap P "_c<C-R>*<esc>
    set ideajoin # `J` to join lines
    set ideaput  # clipboard integration
    set showmode
    set commentary
    set surround
    map sa ys
    map sr cs
    map sd ds
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
  '';
}

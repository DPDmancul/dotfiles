{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    unfree.jetbrains.rider
  ];

  xdg.configFile."ideavim/ideavimrc".text = ''
    source ~/.config/nvim/init-home-manager.vim
    set ideajoin # `J` to join lines
    set ideaput  # clipboard integration
    set commentary
    set surround
    map sa ys
    map sr cs
    map sd ds
    map <leader>ff <Action>(GotoFile)
    map <leader>fg <Action>(FindInPath)
    map <leader>fb <Action>(Switcher)
    map <leader>fp <Action>(WelcomeScreenRecentProjectActionGroup)
    map <leader>gg <Action>(GitRepositoryActions)

    map ]b <Action>(NextTab)
    map ]B <Action>(MoveTabRight)
    map [b <Action>(PreviousTab)
    map [B <Action>(MoveTabDown)

    map gD <Action>(GotoDeclaration)
    map gI <Action>(GotoImplementation)
    map <leader>e <Action>(ShowErrorDescription)
    map <leader>cf <Action>(ReformatCode)

    map <C-\> <Action>(ActivateTerminalToolWindow)
  '';
}

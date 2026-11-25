{ config, pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "jetbrainsmono nerd font";
      size = 13 * 72.0 / 96; # 13px @ 96 DPI (72 pt/in)
    };
    # gamma 1.15 (thicker text, useful for light themes), contrast 20% (crisper edges)
    settings.text_composition_strategy = "1.15 20";
    settings.url_style = "single";
    extraConfig = "include ${pkgs.jb-nvim}/extras/kitty/light-theme.auto.conf";
    settings.wayland_titlebar_color = "background";
    settings = {
      tab_bar_edge        = "top";
      tab_bar_style       = "powerline";
      tab_powerline_style = "slanted";
    };
    settings.confirm_os_window_close = -2;
  };
  home.sessionVariables.NEWT_COLORS_FILE = pkgs.writeText "newt_colors"
    ''
    root=black,default
    border=gray,default
    window=black,default
    shadow=default,gray
    title=blue,default
    button=white,blue
    actbutton=white,cyan
    checkbox=black,default
    actcheckbox=white,blue
    entry=black,lightgray
    label=black,default
    listbox=black,default
    actlistbox=white,blue
    textbox=black,default
    acttextbox=white,blue
    helpline=gray,default
    roottext=gray,default
    emptyscale=lightgray
    fullscale=blue
    disentry=gray,default
    compactbutton=black,default
    actsellistbox=white,blue
    sellistbox=blue,default
    '';
  xdg.desktopEntries.nvim = lib.mkIf config.programs.neovim.enable {
    name = "NeoVim";
    genericName = "Text Editor";
    icon = "nvim";
    exec = "kitty nvim %F";
    terminal = false;
    categories = [ "Utility" "TextEditor" ];
    mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
  };
}

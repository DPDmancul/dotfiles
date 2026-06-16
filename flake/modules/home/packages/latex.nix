{ config, pkgs, lib, ... }:
{
  imports = [
    ../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    python3Packages.pygments
    textidote
  ];
  programs.neovim.extraConfig = ''
    let g:tex_flavor = 'latex'
  '';

  nvimLSP.texlab = pkgs.texlab;
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = vimtex;
      config = ''
        let g:vimtex_view_general_viewer =  'okular'
      '';
      type = "viml";
    }
  ];
}

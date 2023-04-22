{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  nvimLSP = with pkgs; {
    html = rec {
      package = nodePackages.vscode-langservers-extracted;
      config.cmd = ["${package}/bin/vscode-html-language-server" "--stdio"];
    };
    cssls = rec {
      package = nodePackages.vscode-langservers-extracted;
      config.cmd = ["${package}/bin/vscode-css-language-server" "--stdio"];
    };
  };
}

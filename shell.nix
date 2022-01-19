{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    emacs
    (
      with emacs27Packages; [
        org
        org-contrib
        babel
        htmlize
        nix-mode
        # toml-mode
        # lua-mode
        # vimrc-mode
        # fish-mode
      ]
    )
    home-manager
  ];
}

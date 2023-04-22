{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    lilypond # frescobaldi
    (symlinkJoin {
      name = "fluidsynth";
      paths = [ fluidsynth ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/fluidsynth \
          --add-flags "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
      '';
    })
    qsynth
  ];
  programs.neovim.plugins = with pkgs; with vimPlugins; [
    nui-nvim
    {
      plugin = (vimUtils.buildVimPlugin rec {
        name = "nvim-lilypond-suite";
        src = fetchFromGitHub {
          owner = "martineausimon";
          repo = name;
          rev = "803bf45a46c234bd18dbee6668460cea83a8172e";
          sha256 = "nbqywtDOLS6bco+tLqAmZYvG5Ol0qE4EcXVvWHwXK0s=";
        };
      });
    }
  ];
}

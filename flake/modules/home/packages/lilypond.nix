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
    nvim-lilypond-suite
  ];
}

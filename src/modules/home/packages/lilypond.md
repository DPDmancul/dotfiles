# Lilypond

```nix modules/home/packages/lilypond.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    lilypond # frescobaldi
    <<<modules/home/packages/lilypond-packages>>>
  ];
  <<<modules/home/packages/lilypond>>>
}
```

Lilypond requires a midi synth:

```nix "modules/home/packages/lilypond-packages" +=
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
```

### Neovim support

```nix "modules/home/packages/lilypond" +=
programs.neovim.plugins = with pkgs; with vimPlugins; [
  nui-nvim
  nvim-lilypond-suite
];
```


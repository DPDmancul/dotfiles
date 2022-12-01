{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    python3Packages.pygments
    (pkgs.stdenvNoCC.mkDerivation rec {
      preferLocalBuild = true;
      pname = "textidote";
      version = "0.8.3";
      dontUnpack = true;
      dontConfigure = true;

      src = fetchurl {
        url = "https://github.com/sylvainhalle/${pname}/releases/download/v${version}/${pname}.jar";
        sha256 = "BIYswDrVqNEB+J9TwB0Fop+AC8qvPo53KGU7iupC7tk=";
      };

      buildPhase = ''
        cat > ${pname} << EOF
        #!/bin/sh
        exec ${openjdk_headless}/bin/java -jar $src \$@
      '';

      installPhase = ''
        install -Dm555 -t $out/bin ${pname}
      '';
    })
  ];
  programs.neovim.extraConfig = ''
    let g:tex_flavor = 'latex'
  '';
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = vimtex;
      config = ''
        let g:vimtex_view_general_viewer =  'okular'
      '';
    }
  ];
}

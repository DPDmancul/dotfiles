{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gnumake
    git-crypt
    mdbook
    (
      buildGoPackage rec {
        pname = "lmt";
        version = "3-8-2021";

        goPackagePath = "main";

        src = fetchFromGitHub {
          owner = "driusan";
          repo = pname;
          rev = "a940ba5299babf61ab6dfc72f308ea362cb6e4ec";
          sha256 = "0jpiv9xm8wbi8rdfkkqfhqmjqqfzzhbwwh9m2n52cy4dxbfs8wbh";
        };

        postInstall = ''
          mv $out/bin/main $out/bin/lmt
        '';
      }
    )
    home-manager
  ];
}

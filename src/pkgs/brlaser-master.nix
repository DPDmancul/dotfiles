{ pkgs }:
pkgs.brlaser.overrideAttrs (finalAttrs: previousAttrs: {
  src = pkgs.fetchFromGitHub {
    owner = "Owl-Maintain";
    repo = "brlaser";
    rev = "bfaf936bf46f7d3a8a993352fbbb9615b4fc532a";
    sha256 = "d5pS75Z7iUaw8qo4U6tqsZR7IJa/PJzJUApz/27elaM=";
  };
})

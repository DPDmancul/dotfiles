{ pkgs, lib }:
  with lib; with builtins;
  genAttrs
    (filter (name: name != "default")
      (concatMap (match "(.*)\.nix") (attrNames (readDir ./.))))
    (pkg: pkgs.callPackage ./${pkg}.nix { })

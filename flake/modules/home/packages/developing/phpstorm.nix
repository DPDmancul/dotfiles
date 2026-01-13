{ config, pkgs, lib, inputs, ... }:
{
  home.packages = with pkgs; [
    # use jdk 21.0.6 since newer jdks use wrong mouse cursor and apply a wrong window geometry
    (unfree.callPackage "${inputs.unstable}/pkgs/applications/editors/jetbrains/default.nix" { inherit (pkgs."25.05".jetbrains) jdk; }).phpstorm
  ];
}

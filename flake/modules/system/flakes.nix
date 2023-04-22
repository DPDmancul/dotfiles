{ config, inputs, pkgs, lib, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}

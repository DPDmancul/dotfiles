{ config, pkgs, lib, assets, ... }:
{
  sops.secrets."users/PereBook/dpd-/password".neededForUsers = true;
  users.users.dpd- = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/PereBook/dpd-/password".path;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
    ];
  };
}

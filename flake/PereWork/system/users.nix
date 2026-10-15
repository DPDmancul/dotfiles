{ config, pkgs, lib, assets, ... }:
{
  sops.secrets."users/PereWork/dpd-/password".neededForUsers = true;
  users.users.dpd- = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/PereWork/dpd-/password".path;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
      "libvirtd" # virtualisation
      "vboxusers"
    ];
  };
}

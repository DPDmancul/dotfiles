{ config, pkgs, secrets, lib, ... }:
{
  users.mutableUsers = false;
  users.users.dpd- = {
    isNormalUser = true;
    hashedPassword = secrets.dpd-.hashedPasswords;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
    ];
  };
}

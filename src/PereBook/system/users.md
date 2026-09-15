# Users

```nix PereBook/system/users.nix
{ config, pkgs, lib, assets, ... }:
{
  <<<PereBook/system/users>>>
}
```

## dpd-

```nix "PereBook/system/users" +=
sops.secrets."users/PereBook/dpd-/password".neededForUsers = true;
users.users.dpd- = {
  isNormalUser = true;
  hashedPasswordFile = config.sops.secrets."users/PereBook/dpd-/password".path;
  extraGroups = [
    "wheel" # Enable 'sudo' for the user.
  ];
};
```


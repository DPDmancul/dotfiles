# Users

```nix PereWork/system/users.nix
{ config, pkgs, lib, assets, ... }:
{
  sops.secrets.users.sopsFile = /${assets}/secrets/users.yaml;

  <<<PereWork/system/users>>>
}
```

## dpd-

```nix "PereWork/system/users" +=
sops.secrets."users/PereBook/dpd-/password".neededForUsers = true;
users.users.dpd- = {
  isNormalUser = true;
  passwordFile = config.sops.secrets."users/PereBook/dpd-/password".path;
  extraGroups = [
    "wheel" # Enable 'sudo' for the user.
  ];
};
```


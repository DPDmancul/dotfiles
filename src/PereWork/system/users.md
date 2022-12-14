# Users

```nix PereWork/system/users.nix
{ config, pkgs, secrets, lib, ... }:
{
  <<<PereWork/system/users>>>
}
```

## dpd-

```nix "PereWork/system/users" +=
users.users.dpd- = {
  isNormalUser = true;
  hashedPassword = secrets."dpd-@${config.networking.hostName}".hashedPassword;
  extraGroups = [
    "wheel" # Enable 'sudo' for the user.
  ];
};
```


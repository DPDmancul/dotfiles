# Users

Users must follow this config and cannot be modified outside it

```nix PereBook/system/users.nix
{ config, pkgs, secrets, lib, ... }:
{
  users.mutableUsers = false;
  <<<PereBook/system/users>>>
}
```

## Users

### dpd-

```nix "PereBook/system/users" +=
users.users.dpd- = {
  isNormalUser = true;
  hashedPassword = secrets."dpd-@${config.networking.hostName}".hashedPassword;
  extraGroups = [
    "wheel" # Enable 'sudo' for the user.
  ];
};
```


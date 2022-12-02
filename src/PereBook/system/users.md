# Users

```nix PereBook/system/users.nix
{ config, pkgs, secrets, lib, ... }:
{
  <<<PereBook/system/users>>>
}
```

## dpd-

```nix "PereBook/system/users" +=
users.users.dpd- = {
  isNormalUser = true;
  hashedPassword = secrets."dpd-@${config.networking.hostName}".hashedPassword;
  extraGroups = [
    "wheel" # Enable 'sudo' for the user.
  ];
};
```


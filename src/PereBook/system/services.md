# Services

```nix PereBook/system/services.nix
{ config, pkgs, users, lib, ... }:
{
  <<<PereBook/system/services>>>
}
```

## ADB

```nix "PereBook/system/services" +=
programs.adb.enable = true;
```

Add user to the adb group

```nix "PereBook/system/services" +=
users.users = lib.genAttrs users (user: {
  extraGroups = [
    "adbusers"
  ];
});
```


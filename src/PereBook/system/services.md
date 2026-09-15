# Services

```nix PereBook/system/services.nix
{ config, pkgs, users, lib, ... }:
{
  <<<PereBook/system/services>>>

  environment.systemPackages = with pkgs; [
    <<<PereBook/system/services-packages>>>
  ];
}
```

## ADB

```nix "PereBook/system/services-packages" +=
android-tools
```

Add user to the adb group

```nix "PereBook/system/services" +=
users.users = lib.genAttrs users (user: {
  extraGroups = [
    "adbusers"
  ];
});
```


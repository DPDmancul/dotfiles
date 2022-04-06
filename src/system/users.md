# Users

Users must follow this config and cannot be modified outside it

```nix "config" +=
users.mutableUsers = false;
```

## Users

### dpd-

```nix "config" +=
users.users.dpd- = {
  isNormalUser = true;
  hashedPassword = secrets.dpd-.hashedPasswords;
  extraGroups = [
    "wheel" # Enable 'sudo' for the user.
    "networkmanager"
    "input"
    "video"
    "kvm" # qemu
  ];
};
```


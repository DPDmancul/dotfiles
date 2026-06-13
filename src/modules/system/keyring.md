# Gnome Keyring

Enable Gnome Keyring and seahorse

```nix modules/system/keyring.nix
{ config, pkgs, lib, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  environment.extraInit = lib.mkIf config.services.gnome.gcr-ssh-agent.enable ''
    if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    fi
  '';
}
```

# GnuPG

Enable Gnu Privacy Guard

```nix "home-config" +=
programs.gpg.enable = true;
services.gpg-agent.enable = true;
```

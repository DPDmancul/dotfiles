# SSH

```nix modules/home/ssh.nix
{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # to be ready for future releases of home-manager
    settings = {
      <<<modules/home/ssh-hosts>>>
    };
  };
  # <<<modules/home/ssh>>>
}
```

## Multiplexing

Reuse TCP connections to avoid re-authenticating (e.g. for `scp` when already logged in `ssh`)

```nix "modules/home/ssh-hosts" +=
"*" = {
  controlPath = "~/.ssh/master-%r@%n:%p";
  controlMaster = "auto";
  controlPersist = "10m";
};
```

## Hosts

### Git remotes

Login to git remotes using keys, instead of writing the password each time

```nix "modules/home/ssh-hosts" +=
"gitlab.com" = {
  user         = "git";
  identityFile = "~/.ssh/dpd-GitLab";
};
"github.com" = {
  user         = "git";
  identityFile = "~/.ssh/dpd-GitHub";
};
```

## Private keys

What?

You must **never share private keys**!!!


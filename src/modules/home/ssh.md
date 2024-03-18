# SSH

```nix modules/home/ssh.nix
{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      <<<modules/home/ssh-hosts>>>
    };
    <<<modules/home/ssh-config>>>
  };
  # <<<modules/home/ssh>>>
}
```

## Multiplexing

Reuse TCP connections to avoid re-authenticating (e.g. for `scp` when already logged in `ssh`)

```nix "modules/home/ssh-config" +=
controlMaster = "auto";
controlPersist = "10m";
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


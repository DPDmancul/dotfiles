# SSH

```nix modules/home/ssh.nix
{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      <<<modules/home/ssh-hosts>>>
    };
  };
}
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


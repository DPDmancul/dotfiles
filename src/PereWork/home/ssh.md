# SSH

```nix PereWork/home/ssh.nix
{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      <<<PereWork/home/ssh-hosts>>>
    };
  };
}
```

## Hosts

### Git remotes

Login to git remotes using keys, instead of writing the password each time

```nix "PereWork/home/ssh-hosts" +=
"git.mvlabs.it" = {
  user         = "git";
  identityFile = "~/.ssh/MVLabsGit";
};
```

## Private keys

What?

You must **never share private keys**!!!


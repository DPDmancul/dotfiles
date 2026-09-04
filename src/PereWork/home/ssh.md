# SSH

```nix PereWork/home/ssh.nix
{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    settings = {
      <<<PereWork/home/ssh-hosts>>>
    };
  };
}
```

## Hosts

### Git remotes

```nix "PereWork/home/ssh-hosts" +=
"git.mvlabs.it" = {
  user = "git";
  port = 4222;
};
```

## Private keys

What?

You must **never share private keys**!!!


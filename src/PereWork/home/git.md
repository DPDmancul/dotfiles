# git config

```nix PereWork/home/git.nix
{ config, pkgs, lib, ... }:
{
  programs.git.enable = true;

  <<<PereWork/home/git>>>
}
```

## Work git user

```nix "PereWork/home/git" +=
programs.git.includes = [
  {
    condition = "hasconfig:remote.*.url:ssh://git@git.mvlabs.it:*/**";
    contents = {
      user = {
        name = "Davide Peressoni";
        email = "d.peressoni@mvlabs.it";
      };
    };
  }
];
```


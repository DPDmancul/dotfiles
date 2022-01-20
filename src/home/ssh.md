# SSH

```nix "home-config" +=
programs.ssh = {
  enable = true;
  matchBlocks = {
    <<<ssh-hosts>>>
  };
};
```

## Hosts

### Git remotes

Login to git remotes using keys, instead of writing the password each time

```nix "ssh-hosts" +=
"gitlab.com" = {
  user         = "git";
  identityFile = "~/.ssh/dpd-GitLab";
};
"github.com" = {
  user         = "git";
  identityFile = "~/.ssh/dpd-GitHub";
};
```

### AUR

```nix "ssh-hosts" +=
"aur.archlinux.org" = {
  user         = "aur";
  identityFile = "~/.ssh/aur";
};
```

### UniPD DEI

 To log in to remote machines of the Department of Information Engineering at the University of Padua you have to pass through a login server. I set this as a proxy so I don't have to log in twice each time and I can use `scp` without making a temp copy on the login server.

```nix "ssh-hosts" +=
dei = {
  hostname     = "login.dei.unipd.it";
  user         = "peressonid";
  identityFile = "~/.ssh/DEI";
};
capri = {
  proxyJump    = "dei";
  hostname     = "capri.dei.unipd.it";
  user         = "p1045u27";
  identityFile = "~/.ssh/DEI";
};
cloudveneto = {
  proxyJump    = "dei";
  hostname     = "147.162.226.106";
  port         = 2222;
  user         = "group11";
  identityFile = "~/.ssh/DEI";
};
```

### Nas

```nix "ssh-hosts" +=
nassuz = {
  hostname     = "10.10.10.10";
  user         = "admin";
  identityFile = "~/.ssh/nassuz";
};
pc3 = {
  hostname     = "10.10.10.10";
  port         = 822;
  user         = "cominfo";
};
nassuz_web = {
  hostname     = "lon1.tmate.io";
  user         = "cominfo/nassuz";
  identityFile = "~/.ssh/nassuz";
};
```

## Private keys

What?

You must **never share private keys**!!!


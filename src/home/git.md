# git config

```nix "home-config" +=
programs.git = {
  enable = true;
  <<<git-config>>>
  extraConfig = {
    <<<git-settings>>>
  };
};
```

## User config

```nix "git-config" +=
userName = "DPDmancul";
userEmail = "davide.peressoni@tuta.io";
```

## CR/LF

Fix EOL for files written under Windows

```nix "git-settings" +=
core.autoclrf = "input";
```

## Default branch

When creating a new repo, set the default branch to `main`

```nix "git-settings" +=
init.defaultBranch = "main";
```

## Status

```nix "git-settings" +=
status = {
  <<<git-status>>>
};
```

### Untracked files

Show also individual files in untracked directories

```nix "git-status" +=
showUntrackedFiles = "all";
```

### Submodule summary

Enable submodule summary showing the summary of commits for modified submodules

```nix "git-status" +=
submoduleSummary = true;
```

## Fetch

Prune the local tracking branches and tags when fetching from remote

```nix "git-settings" +=
fetch = {
  prune = true;
  pruneTags = true;
};
```

## Pull

When pulling only update the current branch by fast-forwarding

```nix "git-settings" +=
pull = {
  ff = "only";
};
```

## Push

Automatic set default remote when pushing.

```nix "git-settings" +=
push = {
  autoSetupRemote = true;
};
```

## Protocol

 Enable git protocol version 2.

Read [about it](https://about.gitlab.com/2018/12/10/git-protocol-v2-enabled-for-ssh-on-gitlab-dot-com/).

```nix "git-settings" +=
protocol.version = 2;
```

## Credential helper

TODO

## Diff

Delta enhance your git diff output by adding some cool features like syntax highlighting, line numbering, and side-by-side view.

```nix "git-config" +=
delta = {
  enable = true;
  options = {
    features = "interactive";
    wrap-max-lines = "unlimited";
    max-line-length = 2048;
    syntax-theme = "gruvbox-light";
  };
};
```

## LFS

```nix "git-config" +=
lfs.enable = true;
```

## GitUI

```nix "home-config" +=
programs.gitui = {
  enable = true;
};
```

# Global gitignore

```nix "git-config" +=
ignores = [
  <<<git-ignore>>>
];
```

## CCLS LSP

For C code I'm using CCLS with LSP in Neovim. Ignore the files this creates.

```nix "git-ignore" +=
".ccls-cache/"
```

## Directory file

```nix "git-ignore" +=
".directory"
```

## Python cache

```nix "git-ignore" +=
"__pycache__"
".pytest_cache"
```

## NextCloud

```nix "git-ignore" +=
".owncloudsync.log"
"._sync_*.db*"
```

## Private keys

Could save from accidental upload of private keys, but better to keep always an eye open!

```nix "git-ignore" +=
"id_rsa"
"id_rsa_*"
"id_dsa"
"id_dsa_*"
"id_ed25519"
"id_ed25519_*"
"*.key"
"*.pem"
"*.pk"
"*.ppk"
```

# Git attributes

Improve diff output for various file types.

From: <https://tekin.co.uk/2020/10/better-git-diff-output-for-ruby-python-elixir-and-more>

```nix "git-config" +=
attributes = [
  "*.c     diff=cpp"
  "*.h     diff=cpp"
  "*.c++   diff=cpp"
  "*.h++   diff=cpp"
  "*.cpp   diff=cpp"
  "*.hpp   diff=cpp"
  "*.cc    diff=cpp"
  "*.hh    diff=cpp"
  "*.cs    diff=csharp"
  "*.css   diff=css"
  "*.html  diff=html"
  "*.xhtml diff=html"
  "*.ex    diff=elixir"
  "*.exs   diff=elixir"
  "*.go    diff=golang"
  "*.php   diff=php"
  "*.pl    diff=perl"
  "*.py    diff=python"
  "*.md    diff=markdown"
  "*.rb    diff=ruby"
  "*.rake  diff=ruby"
  "*.rs    diff=rust"
  "*.lisp  diff=lisp"
  "*.el    diff=lisp"
];
```



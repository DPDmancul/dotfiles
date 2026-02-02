# git config

```nix modules/home/git.nix
{ config, pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      <<<modules/home/git-settings>>>
    };
    <<<modules/home/git-config>>>
  };

  home.packages = with pkgs; [
    <<<modules/home/git-packages>>>
  ];

  <<<modules/home/git>>>
}
```

## User config

```nix "modules/home/git-settings" +=
user = {
  name = "DPDmancul";
  email = "davide.peressoni@tuta.io";
  signingkey = "694FC712B317CF9004114DC4EC1145E786990CED";
};
commit.gpgsign = true;
tag.gpgSign = true;
```

## Aliases

```nix "modules/home/git-settings" +=
alias = {
  co = "checkout";
  cb = "checkout -b";
  br = "branch";
  ci = "commit";
  st = "status";
  sw = "switch";
  sc = "switch -c";
  rb = "rebase";
};
```

## CR/LF

Fix EOL for files written under Windows

```nix "modules/home/git-settings" +=
core.autoclrf = "input";
```

## Default branch

When creating a new repo, set the default branch to `main`

```nix "modules/home/git-settings" +=
init.defaultBranch = "main";
```

## Status

Show also individual files in untracked directories

```nix "modules/home/git-settings" +=
status.showUntrackedFiles = "all";
```

Enable submodule summary showing the summary of commits for modified submodules

```nix "modules/home/git-settings" +=
extraConfig.status.submoduleSummary = true;
```

## Fetch

Prune the local tracking branches and tags when fetching from remote

```nix "modules/home/git-settings" +=
fetch = {
  prune = true;
  pruneTags = true;
};
```

## Pull

When pulling only update the current branch by fast-forwarding

```nix "modules/home/git-settings" +=
pull = {
  ff = "only";
};
```

## Push

Automatic set default remote when pushing.

```nix "modules/home/git-settings" +=
push = {
  autoSetupRemote = true;
};
```

## Rerere

Reuse recorded conflict resolutions

```nix "modules/home/git-settings" +=
rerere.enabled = true;
```

## Protocol

Enable git protocol version 2.

Read [about it](https://about.gitlab.com/2018/12/10/git-protocol-v2-enabled-for-ssh-on-gitlab-dot-com/).

```nix "modules/home/git-settings" +=
protocol.version = 2;
```

## Credential helper

TODO

## Diff

Delta enhance your git diff output by adding some cool features like syntax highlighting, line numbering, and side-by-side view.

```nix "modules/home/git" +=
programs.delta = {
  enable = true;
  enableGitIntegration = true;
  options = {
    features = "interactive";
    wrap-max-lines = "unlimited";
    max-line-length = 2048;
    syntax-theme = "gruvbox-light";
  };
};
```

## LFS

```nix "modules/home/git-config" +=
lfs.enable = true;
```

## Filter repo

Install git-filter-repo, which [replaces git-filter-branch](https://git-scm.com/docs/git-filter-branch#_warning)

```nix "modules/home/git-packages" +=
git-filter-repo
```

## Lazy git

```nix "modules/home/git" +=
programs.lazygit = {
  enable = true;
  settings = {
    gui = {
      theme = {
        selectedLineBgColor = [ "#d5c4a1" ];
        selectedRangeBgColor = [ "#d5c4a1" ];
      };
      showIcons = true;
    };
    git.pagers = [
      { pager = "delta --paging=never"; }
    ];
  };
};
```

# Global gitignore

```nix "modules/home/git-config" +=
ignores = [
  <<<modules/home/git-ignore>>>
];
```

## CCLS LSP

For C code I'm using CCLS with LSP in Neovim. Ignore the files this creates.

```nix "modules/home/git-ignore" +=
".ccls-cache/"
```

## Directory file

```nix "modules/home/git-ignore" +=
".directory"
```

## LLM settings

```nix "modules/home/git-ignore" +=
"**/.claude/settings.local.json"
```

## Python cache

```nix "modules/home/git-ignore" +=
"__pycache__"
".pytest_cache"
```

## NextCloud

```nix "modules/home/git-ignore" +=
".owncloudsync.log"
"._sync_*.db*"
```

## Private keys

Could save from accidental upload of private keys, but better to keep always an eye open!

```nix "modules/home/git-ignore" +=
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

```nix "modules/home/git-config" +=
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


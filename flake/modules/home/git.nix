{ config, pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    userName = "DPDmancul";
    userEmail = "davide.peressoni@tuta.io";
    signing = {
      key = "694FC712B317CF9004114DC4EC1145E786990CED";
      signByDefault = true;
    };
    extraConfig.core.autoclrf = "input";
    extraConfig.init.defaultBranch = "main";
    extraConfig.status.showUntrackedFiles = "all";
    extraConfig.status.submoduleSummary = true;
    extraConfig.fetch = {
      prune = true;
      pruneTags = true;
    };
    extraConfig.pull = {
      ff = "only";
    };
    extraConfig.push = {
      autoSetupRemote = true;
    };
    extraConfig.protocol.version = 2;
    delta = {
      enable = true;
      options = {
        features = "interactive";
        wrap-max-lines = "unlimited";
        max-line-length = 2048;
        syntax-theme = "gruvbox-light";
      };
    };
    lfs.enable = true;
    ignores = [
      ".ccls-cache/"
      ".directory"
      "__pycache__"
      ".pytest_cache"
      ".owncloudsync.log"
      "._sync_*.db*"
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
    ];
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
  };

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
      git.paging.pager = "delta --paging=never";
    };
  };
}

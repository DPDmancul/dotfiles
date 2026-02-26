# Tide

Use tide to manage the prompt

```nix modules/home/tide.nix
{ config, pkgs, lib, ... }:
{
  programs.fish = {
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "v6.2.0";
          hash = "sha256-1ApDjBUZ1o5UyfQijv9a3uQJ/ZuQFfpNmHiDWzoHyuw=";
        };
      }
    ];
    interactiveShellInit = lib.concatLines (
      lib.mapAttrsToListRecursive
        (path: value: ''set -x tide_${lib.concatStringsSep "_" path} "${lib.escapeShellArg value}"'')
        {
          left_prompt.frame_enabled = "true";
        }
    );
  };
}
```

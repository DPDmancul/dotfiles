# Tide

Use tide to manage the prompt

```nix modules/home/tide.nix
{ config, pkgs, lib, ... }:
{
  programs.fish = {
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
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

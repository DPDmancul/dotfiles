# Claude

```nix PereWork/home/claude.nix
{ config, pkgs, lib, ... }:
{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    package = pkgs.unfree.claude-code;
    settings = {
      <<<PereWork/home/claude-settings>>>
    };
    <<<PereWork/home/claude-config>>>
  };
}
```

Get up to date claude via an overlay

```nix overlays/claude-code.nix
final: prev: {
  claude-code =
    let
      manifest = prev.lib.importJSON ../assets/claude-code.json;
      noOverride = prev.lib.versionAtLeast prev.claude-code.version manifest.version;
    in
      prev.lib.warnIf noOverride "claude-code from nixpkgs is newer than override" (
        if noOverride then prev.claude-code
        else prev.claude-code.override { inherit manifest; }
      );
}
```

## Base settings

```nix "PereWork/home/claude-settings" +=
autoMemoryEnabled = false;
preferredNotifChannel = "notifications_disabled";
```

## Status line

```nix "PereWork/home/claude-settings" +=
statusLine = {
  type = "command";
  command = pkgs.writeShellScript "claude-status-line.sh" (builtins.readFile ./claude-status-line.sh);
};
```

```sh PereWork/home/claude-status-line.sh
#! /user/bin/env bash

# Read JSON input from stdin
input=$(cat)

# Extract rate limit data
five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
weekly_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Extract model and workspace info
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
workspace=$(echo "$input" | jq -r '.workspace.current_dir // ""')

# Build status line parts
parts=()

# Add model name
parts+=("$model")

# Add workspace (show directory name if available)
if [ -n "$workspace" ]; then
    dir_name=$(basename "$workspace")
    parts+=("$dir_name")
fi

# Add rate limits if available
# Format: 5h: X% | 7d: Y%
if [ -n "$five_hour_used" ]; then
    parts+=("5h: ${five_hour_used}%")
fi
if [ -n "$weekly_used" ]; then
    parts+=("7d: ${weekly_used}%")
fi

# Join parts with " | "
status=""
for i in "${!parts[@]}"; do
    if [ "$i" -eq 0 ]; then
        status="${parts[$i]}"
    else
        status="$status | ${parts[$i]}"
    fi
done

echo "$status"
```

## Context

```nix "PereWork/home/claude-config" +=
context = ''
  <<<PereWork/home/claude-context>>>
'';
```

### NixOs

```md "PereWork/home/claude-context" +=
# Environment: NixOS

The system is NixOS. Python (and other tooling) is NOT installed globally, and I do not use pip, uv, pipx, poetry, or other language-level package managers: Nix manages everything.

- Never conclude "python is not installed" or "uv is not installed" and give up or suggest installing via pip/uv/apt.
- When Python is needed, run it through Nix, e.g. `nix-shell -p python3 --run "python3 script.py"`.
- For Python packages, add them to the same shell: `nix-shell -p "python3.withPackages (ps: [ ps.requests ps.pyyaml ])" --run "python3 script.py"`.
- The same applies to any other missing tool: use `nix-shell -p <package> --run "<cmd>"` instead of installing it.
```

## Plugins

```nix "PereWork/home/claude-settings" +=
enabledPlugins."superpowers@claude-plugins-official" = true;

enabledPlugins."bmad-method@bmad" = true;
extraKnownMarketplaces."bmad" = {
  source = {
    source = "github";
    repo = "bmad-code-org/bmad-plugins";
  };
};

enabledPlugins."i-have-adhd@i-have-adhd" = true;
extraKnownMarketplaces."i-have-adhd" = {
  source = {
    source = "github";
    repo = "ayghri/i-have-adhd";
  };
};
```

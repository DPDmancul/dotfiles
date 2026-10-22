{ config, pkgs, lib, ... }:
{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    package = pkgs.unfree.claude-code;
    settings = {
      autoMemoryEnabled = false;
      preferredNotifChannel = "notifications_disabled";
      statusLine = {
        type = "command";
        command = pkgs.writeShellScript "claude-status-line.sh" (builtins.readFile ./claude-status-line.sh);
      };
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
    };
    context = ''
      # Environment: NixOS

      The system is NixOS. Python (and other tooling) is NOT installed globally, and I do not use pip, uv, pipx, poetry, or other language-level package managers: Nix manages everything.

      - Never conclude "python is not installed" or "uv is not installed" and give up or suggest installing via pip/uv/apt.
      - When Python is needed, run it through Nix, e.g. `nix-shell -p python3 --run "python3 script.py"`.
      - For Python packages, add them to the same shell: `nix-shell -p "python3.withPackages (ps: [ ps.requests ps.pyyaml ])" --run "python3 script.py"`.
      - The same applies to any other missing tool: use `nix-shell -p <package> --run "<cmd>"` instead of installing it.
    '';
  };
}

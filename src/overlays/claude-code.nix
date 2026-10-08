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

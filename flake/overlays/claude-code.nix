final: prev: {
  claude-code =
    let
      version = "2.1.294";
      noOverride = prev.lib.versionAtLeast prev.claude-code.version version;
    in
      prev.lib.warnIf noOverride "claude-code from nixpkgs is newer than override" (
        if noOverride then prev.claude-code
        else
          prev.claude-code.override {
            manifest = prev.lib.importJSON (prev.fetchurl {
              url = "https://downloads.claude.ai/claude-code-releases/${version}/manifest.json";
              sha256 = "sha256-Jp4O0c9T+V9YDQiKDRRVgFdkjf5BgSirZp4isPAZaac=";
            });
          }
      );
}

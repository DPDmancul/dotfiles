# User packages

```nix PereWork/home/packages.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home/xdg.nix
    /${modules}/home/packages/developing/dotnet.nix
    /${modules}/home/packages/developing/rider.nix
    /${modules}/home/packages/developing/node.nix
    /${modules}/home/packages/developing/php.nix
    /${modules}/home/packages/developing/phpstorm.nix
    /${modules}/home/packages/developing/haskell.nix
  ];

  home.packages = with pkgs; let
    openvpn_legacy = openvpn.override { openssl = openssl_legacy; };
  in
  [
    #<<<PereWork/home/packages-packages>>>
    appimage-run
    openvpn
    (writeScriptBin "openvpn_legacy" ''${openvpn_legacy}/bin/openvpn "$@"'')
    openconnect gp-saml-gui
    remmina
    postgresql # TODO install only client
    # unfree.redisinsight
    unfree.drawio
    unfree.postman
    bruno
    wireshark
    <<<PereWork/home/packages-packages>>>
  ];

  #<<<PereWork/home/packages>>>
}
```

## LLMs

```nix "PereWork/home/packages-packages" +=
unfree.claude-code
(python3Packages.buildPythonPackage rec {
  pname = "code-review-graph";
  version = "2.3.6";
  src = fetchFromGitHub {
    owner = "tirth8205";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-akuk4UHOTfw66dnuAeqoCkqF/JzsHqSzoTk5MQhEd0o=";
  };
  pyproject = true;
  build-system = with python3Packages; [
    hatchling
  ];
  dependencies = with python3Packages; [
    mcp
    fastmcp
    networkx
    tree-sitter
    tree-sitter-language-pack
    watchdog
  ];
  pythonRelaxDeps = [
    "fastmcp"
    "tree-sitter-language-pack"
    "watchdog"
  ];
 })
```

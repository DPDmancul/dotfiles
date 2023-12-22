{ config, pkgs, lib, ... }:
let
  dotnet-sdk = with pkgs.next.dotnetCorePackages; combinePackages [
    sdk_8_0
    sdk_6_0
  ];
in
{
  home.packages = with pkgs; [
    dotnet-sdk
  ];

  home.sessionVariables = {
    DOTNET_ROOT = dotnet-sdk;
    # disable telemetry
    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
  };

  nvimLSP.csharp_ls = [];
  home.sessionPath = [
    "${config.home.homeDirectory}/.dotnet/tools"
  ];
}

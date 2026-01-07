{ config, pkgs, lib, ... }:
let
  dotnet-sdk = with pkgs.dotnetCorePackages; combinePackages [
    sdk_10_0
    sdk_8_0
  ];
in
{
  home.packages = with pkgs; [
    dotnet-sdk
    nuget
    dotnet-ef
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-sdk}/share/dotnet";
    # disable telemetry
    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
  };

  # nvimLSP.csharp_ls = [];
  # home.sessionPath = [
  #   "${config.home.homeDirectory}/.dotnet/tools"
  # ];
}

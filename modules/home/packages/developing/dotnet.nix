{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    dotnet-sdk
  ];

  home.sessionVariables = {
    DOTNET_ROOT = pkgs.dotnet-sdk;
    # disable telemetry
    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
  };

  nvimLSP.csharp_ls = [];
  home.sessionPath = [
    "${config.home.homeDirectory}/.dotnet/tools"
  ];
}

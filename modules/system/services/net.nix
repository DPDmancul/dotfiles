{ config, pkgs, assets, lib, users, ... }:
{
  networking.networkmanager.enable = true;
  sops.secrets = let
    sopsFile = /${assets}/secrets/nm.yaml;
  in with lib; with builtins; genAttrs
    (filter isString
      (concatMap (match ''([^ \t#"][^:]*):.*|"([^"])":.*|.*'') 
                 (splitString "\n" (readFile sopsFile))))
    (key: mkIf (key != "sops") {
      path = "/etc/NetworkManager/system-connections/${key}";
      inherit sopsFile;
    });

  users.users = lib.genAttrs users (user: {
    extraGroups = [
      "networkmanager"
    ];
  });
}

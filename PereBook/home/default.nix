{ config, pkgs, lib, modules, assets, ... }:
{
  imports = [
    /${modules}/home
    /${modules}/home/wm/sway.nix
    /${modules}/home/wm/i3.nix
    ./packages.nix
  ];

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "batt" ''
      ${bluetooth_battery}/bin/bluetooth_battery AC:12:2F:50:BB:3A
    '')
  ];
  xdg.configFile."OpenTabletDriver/settings.json".source = /${assets}/tablet.json;
}

{ config, pkgs, lib, ... }:
{
  xsession.windowManager.i3.config = {
    workspaceOutputAssign = [
      {wokrspace = "10"; output = "eDP-1";}
      {wokrspace = "1"; output = ["DP-3-1-8" "eDP-1"];}
      {wokrspace = "2"; output = "DP-3-8";}
    ];
  };
}

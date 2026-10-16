{ config, pkgs, lib, ... }:
{
  xsession.windowManager.i3.config = {
    workspaceOutputAssign = [
      {workspace = "10"; output = "eDP-1";}
      {workspace = "1"; output = ["DP-3-1-8" "eDP-1"];}
      {workspace = "2"; output = "DP-3-8";}
    ];
  };
}

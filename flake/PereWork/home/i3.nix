{ config, pkgs, lib, ... }:
{
  xsession.windowManager.i3.config = {
    workspaceOutputAssign = [
      {workspace = "10"; output = "eDP-1";}
      {workspace = "1"; output = ["DP-3-1-8" "eDP-1"];}
    ] ++ lib.map (x: {workspace = lib.toString x; output = "DP-3-8";}) (lib.range 2 9);
  };
}

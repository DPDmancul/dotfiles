{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./default.nix
  ];

  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.package = pkgs.unstable.i3; # TODO stable after gaps being merged

  home.sessionVariables.XDG_CURRENT_DESKTOP = "i3";
  services.picom.enable = true;

  home.packages = with pkgs; [
    xclip
  ];
}

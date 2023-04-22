{ config, pkgs, lib, ... }:
{
  programs.git.enable = true;

  programs.git.includes = [
    {
      condition = "hasconfig:remote.*.url:ssh://git@git.mvlabs.it:*/**";
      contents = {
        user = {
          name = "Davide Peressoni";
          email = "d.peressoni@mvlabs.it";
          signingKey = "C326CCA55860233AA83778F6047114319C2F3D66";
        };
      };
    }
  ];
}

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
        };
      };
    }
  ];
}

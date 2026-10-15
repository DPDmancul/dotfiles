{ config, pkgs, lib, ... }:
{
  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";      # ISO 8601
      LC_PAPER = "it_IT.UTF-8";     # A4
      LC_MONETARY = "it_IT.UTF-8";  # €
    };
  };

  services.xserver.xkb.layout = "eu";
}

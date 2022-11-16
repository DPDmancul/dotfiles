{ config, pkgs, lib, ... }:
{
  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8"; # ISO 8601
      LC_PAPER = "fur_IT";     # A4
      LC_MONETARY = "fur_IT";  # €
    };
  };
}

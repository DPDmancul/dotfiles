{ config, pkgs, lib, ... }:
{
  imports = [
    ../xdg.nix
  ];
  
  home.packages = with pkgs; [
    libreoffice
    hunspell
    hunspellDicts.it_IT
    hunspellDicts.en_US
  ];

  appDefaultForMimes = {
  "writer.desktop".application = [
    "vnd.oasis.opendocument.text"
    "msword"
    "vnd.ms-word"
    "vnd.openxmlformats-officedocument.wordprocessingml.document"
    "vnd.oasis.opendocument.text-template"
  ];
  "calc.desktop".application = [
    "vnd.oasis.opendocument.spreadsheet"
    "vnd.ms-excel"
    "vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "vnd.oasis.opendocument.spreadsheet-template"
  ];
  "impress.desktop".application = [
    "vnd.oasis.opendocument.presentation"
    "vnd.ms-powerpoint"
    "vnd.openxmlformats-officedocument.presentationml.presentation"
    "vnd.oasis.opendocument.presentation-template"
  ];
  "libreoffice.desktop".application = [
    "vnd.oasis.opendocument.graphics"
    "vnd.oasis.opendocument.chart"
    "vnd.oasis.opendocument.formula"
    "vnd.oasis.opendocument.image"
    "vnd.oasis.opendocument.text-master"
    "vnd.sun.xml.base"
    "vnd.oasis.opendocument.base"
    "vnd.oasis.opendocument.database"
    "vnd.oasis.opendocument.graphics-template"
    "vnd.oasis.opendocument.chart-template"
    "vnd.oasis.opendocument.formula-template"
    "vnd.oasis.opendocument.image-template"
    "vnd.oasis.opendocument.text-web"
  ];
};
}

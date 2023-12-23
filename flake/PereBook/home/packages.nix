{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home/xdg.nix
    /${modules}/home/packages/latex.nix
    /${modules}/home/packages/lilypond.nix
    /${modules}/home/packages/developing/rust.nix
    /${modules}/home/packages/developing/python3.nix
    /${modules}/home/packages/developing/dotnet.nix
    /${modules}/home/packages/developing/rider.nix
    /${modules}/home/packages/developing/node.nix
    /${modules}/home/packages/developing/web.nix
  ];

  home.packages = with pkgs; [
    diffpdf
    # pdfmixtool
    xournalpp # TODO rnote?
    ocrmypdf tesseract
    unfree.masterpdfeditor4
    calibre
    jmtpfs # For kindle
    gnome.simple-scan
    audacity
    ardour
    # denemo
    musescore
    ffmpeg
    handbrake
    mkvtoolnix
    kdenlive
    losslesscut-bin
    obs-studio
    tor-browser-bundle-bin
    clipgrab
    qbittorrent
    sqlite
    sqlitebrowser
    tdesktop # Telegram
    ipscan
    libfaketime
  ];

  appDefaultForMimes."telegramdesktop.desktop" = "x-scheme-handler/tg";
}

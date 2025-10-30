{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home/xdg.nix
    /${modules}/home/packages/latex.nix
    # /${modules}/home/packages/lilypond.nix
    /${modules}/home/packages/developing/haskell.nix
    /${modules}/home/packages/developing/rust.nix
    /${modules}/home/packages/developing/python3.nix
    /${modules}/home/packages/developing/dotnet.nix
    /${modules}/home/packages/developing/node.nix
    /${modules}/home/packages/developing/web.nix
  ];

  home.packages = with pkgs; [
    diffpdf
    # pdfmixtool
    xournalpp # TODO rnote?
    ocrmypdf tesseract
    unfree.masterpdfeditor4
    poppler_utils
    texlivePackages.pdfbook2
    qpdf
    calibre
    jmtpfs # For kindle
    simple-scan
    audacity
    ardour
    musescore-appimage
    ffmpeg
    handbrake
    mkvtoolnix
    kdePackages.kdenlive frei0r
    losslesscut-bin
    obs-studio
    tor-browser-bundle-bin
    wgnord
    clipgrab
    qbittorrent
    sqlite
    sqlitebrowser
    tdesktop # Telegram
    ipscan
    libfaketime
    previous.perl540Packages.AppMusicChordPro
  ];

  appDefaultForMimes."telegramdesktop.desktop" = "x-scheme-handler/tg";
}

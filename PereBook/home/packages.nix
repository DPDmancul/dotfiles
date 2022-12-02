{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home/packages/latex.nix
    /${modules}/home/packages/lilypond.nix
    /${modules}/home/packages/developing/rust.nix
    /${modules}/home/packages/developing/python3.nix
    /${modules}/home/packages/developing/dotnet.nix
  ];

  home.packages = with pkgs; [
    neovim-remote
    nodePackages.pnpm
    # You must manually install `pnpm i -g eslint`
    # and run `pnpx eslint --init` in all projects
    # TODO remove previous in favour of
    diffpdf
    pdfmixtool
    xournalpp # TODO rnote?
    ocrmypdf tesseract
    unfree.masterpdfeditor4
    calibre
    jmtpfs # For kindle
    gimp
    kolourpaint
    inkscape
    gnome.simple-scan
    audacity
    # denemo
    musescore
    ffmpeg
    handbrake
    mkvtoolnix
    kdenlive
    losslesscut-bin
    obs-studio
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })
    clipgrab
    qbittorrent
    sqlitebrowser
    tdesktop # Telegram
    simplenote
    ipscan
    libfaketime
  ];

  appDefaultForMimes."telegramdesktop.desktop" = "x-scheme-handler/tg";
}

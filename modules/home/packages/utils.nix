{ config, pkgs, lib, modules, ... }:
{
  imports = [
    ../xdg.nix
  ];

  home.packages = with pkgs; [
    (symlinkJoin {
      name = "file-roller";
      paths = [ gnome.file-roller ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/file-roller \
          --prefix PATH : "${writeShellScriptBin "gnome-terminal" ''"${kitty}/bin/kitty" $@''}/bin"
      '';
    })
    libsForQt5.okular
    imv
    mpv
    qalculate-gtk
    gnome.gnome-disk-utility
    dua # disk usage
  ];
  appDefaultForMimes."org.gnome.FileRoller.desktop".application = [ "zip" "rar" "7z" "x-tar" "x-gtar" "gnutar" ];
  appDefaultForMimes."okularApplication_pdf.desktop" = {
    application = "pdf";
    image = [ "vnd.djvu" "x.djvu" ];
  };
  appDefaultForMimes."imv-folder.desktop".image = [ "png" "jpeg" "gif" "svg" "svg+xml" "tiff" "x-tiff" "x-dcraw" ];
  appDefaultForMimes."umpv.desktop" = {
    video = [
      "avi" "msvideo" "x-msvideo"
      "mpeg" "x-mpeg" "mp4" "H264" "H265" "x-matroska"
      "ogg"
      "quicktime"
      "webm"
    ];
    audio = [
      "aac" "flac"
      "mpeg" "mpeg3" # mp3
      "ogg" "vorbis" "opus" "x-opus+ogg"
      "wav" "x-wav"
      "audio/x-ms-wma"
    ];
  };
}

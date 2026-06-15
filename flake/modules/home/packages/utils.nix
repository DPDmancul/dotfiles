{ config, pkgs, lib, modules, ... }:
{
  imports = [
    ../xdg.nix
  ];

  home.packages = with pkgs; [
    (symlinkJoin {
      name = "file-roller";
      paths = [ file-roller ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/file-roller \
          --prefix PATH : "${writeShellScriptBin "gnome-terminal" ''"${kitty}/bin/kitty" $@''}/bin"
      '';
    })
    kdePackages.okular
    unfree.masterpdfeditor4
    kdePackages.kolourpaint
    gimp3
    inkscape
    loupe
    qalculate-gtk
    gnome-disk-utility
    dua # disk usage
    jq # cmd json parser
    appimage-run
    localsend
  ];
  appDefaultForMimes."org.gnome.FileRoller.desktop".application = [ "zip" "rar" "7z" "x-tar" "x-gtar" "gnutar" ];
  appDefaultForMimes."okularApplication_pdf.desktop" = {
    application = "pdf";
    image = [ "vnd.djvu" "x.djvu" ];
  };
  appDefaultForMimes."org.gnome.Loupe.desktop".image = [ "png" "jpeg" "jpg" "gif" "svg" "svg+xml" "tiff" "x-tiff" "x-dcraw" "heic" "heif" "webp" ];
  programs.mpv.enable = true;
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
  programs.tealdeer = {
    enable = true;
    settings = {
      updates.auto_update = true;
    };
  };
  programs.parallel = {
    enable = true;
    will-cite = true;
  };
}

# Utilities

```nix modules/home/packages/utils.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    ../xdg.nix
  ];

  home.packages = with pkgs; [
    <<<modules/home/packages/utils-packages>>>
  ];
  <<<modules/home/packages/utils>>>
}
```

## Archive manager

File roller, when needing a terminal, doesn't look for kitty.
So we trick it wrapping kitty as gnome-terminal.

```nix "modules/home/packages/utils-packages" +=
(symlinkJoin {
  name = "file-roller";
  paths = [ gnome.file-roller ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/file-roller \
      --prefix PATH : "${writeShellScriptBin "gnome-terminal" ''"${kitty}/bin/kitty" $@''}/bin"
  '';
})
```

```nix "modules/home/packages/utils" +=
appDefaultForMimes."org.gnome.FileRoller.desktop".application = [ "zip" "rar" "7z" "x-tar" "x-gtar" "gnutar" ];
```

## PDF

```nix "modules/home/packages/utils-packages" +=
libsForQt5.okular
```

```nix "modules/home/packages/utils" +=
appDefaultForMimes."okularApplication_pdf.desktop" = {
  application = "pdf";
  image = [ "vnd.djvu" "x.djvu" ];
};
```

## Drawing

```nix "modules/home/packages/utils-packages" +=
kolourpaint
gimp
inkscape
```

## Image viewer

```nix "modules/home/packages/utils-packages" +=
imv
```

```nix "modules/home/packages/utils" +=
appDefaultForMimes."imv-folder.desktop".image = [ "png" "jpeg" "gif" "svg" "svg+xml" "tiff" "x-tiff" "x-dcraw" ];
```

## Video and audio player

```nix "modules/home/packages/utils-packages" +=
mpv
```

```nix "modules/home/packages/utils" +=
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
```

## Other utilities

```nix "modules/home/packages/utils-packages" +=
qalculate-gtk
gnome.gnome-disk-utility
dua # disk usage
jq # cmd json parser
appimage-run
perl536Packages.AppMusicChordPro
```


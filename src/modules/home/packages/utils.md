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
  paths = [ file-roller ];
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
kdePackages.okular
unfree.masterpdfeditor4
```

```nix "modules/home/packages/utils" +=
appDefaultForMimes."okularApplication_pdf.desktop" = {
  application = "pdf";
  image = [ "vnd.djvu" "x.djvu" ];
};
```

## Drawing

```nix "modules/home/packages/utils-packages" +=
kdePackages.kolourpaint
gimp3
inkscape
```

## Image viewer

```nix "modules/home/packages/utils-packages" +=
loupe
```

```nix "modules/home/packages/utils" +=
appDefaultForMimes."org.gnome.Loupe.desktop".image = [ "png" "jpeg" "jpg" "gif" "svg" "svg+xml" "tiff" "x-tiff" "x-dcraw" "heic" "heif" "webp" ];
```

## Video and audio player

```nix "modules/home/packages/utils" +=
programs.mpv.enable = true;
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
gnome-disk-utility
dua # disk usage
jq # cmd json parser
appimage-run
localsend
```

open ports for localsend (TODO move to this module)

```nix "modules/system" +=
networking.firewall = {
  allowedUDPPorts = [ 53317 ];
  allowedTCPPorts = [ 53317 ];
};
```

tldr: short command examples

```nix "modules/home/packages/utils" +=
programs.tealdeer = {
  enable = true;
  settings = {
    updates.auto_update = true;
  };
};
```


# User packages

```nix PereBook/home/packages.nix
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
    <<<home-packages>>>
    # TODO remove previous in favour of
    <<<PereBook/home/packages-packages>>>
  ];

  <<<PereBook/home/packages>>>
}
```


### PDF utils

```nix "PereBook/home/packages-packages" +=
diffpdf
pdfmixtool
xournalpp # TODO rnote?
ocrmypdf tesseract
unfree.masterpdfeditor4
```

### E-books

```nix "PereBook/home/packages-packages" +=
calibre
jmtpfs # For kindle
```

### Drawing

```nix "PereBook/home/packages-packages" +=
gimp
kolourpaint
inkscape
```

### Scan

```nix "PereBook/home/packages-packages" +=
gnome.simple-scan
```

## Multimedia

### Audio and music production

```nix "PereBook/home/packages-packages" +=
audacity
# denemo
musescore
```
### Video editing and conversion

```nix "PereBook/home/packages-packages" +=
ffmpeg
handbrake
mkvtoolnix
kdenlive
losslesscut-bin
obs-studio
```

## Internet

```nix "PereBook/home/packages-packages" +=
(tor-browser-bundle-bin.override {
  useHardenedMalloc = false;
})
```

### Downloads

```nix "PereBook/home/packages-packages" +=
clipgrab
qbittorrent
```

## Utilities

```nix "PereBook/home/packages-packages" +=
sqlitebrowser
tdesktop # Telegram
simplenote
ipscan
libfaketime
```

```nix "PereBook/home/packages" +=
appDefaultForMimes."telegramdesktop.desktop" = "x-scheme-handler/tg";
```


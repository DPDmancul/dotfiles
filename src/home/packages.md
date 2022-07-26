# User packages

<!--
```nix "comment-home-config" +=
nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) (builtins.split "[ \n]" ''
  <<<home-packages-unfree>>>
'');
home.packages = with pkgs; ([
  <<<home-packages>>>
] ++ [
  <<<home-packages-unfree>>>
]);
```
-->

```nix "home-config" +=
home.packages = with pkgs; [
  <<<home-packages>>>
];
```

## Documents

```nix "home-packages" +=
libreoffice
```

```nix "xdg-mime" +=
(subtypes "application" "libreoffice.desktop"
  [
    "vnd.oasis.opendocument.text"
    "vnd.oasis.opendocument.spreadsheet"
    "vnd.oasis.opendocument.presentation"
    "vnd.oasis.opendocument.graphics"
    "vnd.oasis.opendocument.chart"
    "vnd.oasis.opendocument.formula"
    "vnd.oasis.opendocument.image"
    "vnd.oasis.opendocument.text-master"
    "vnd.sun.xml.base"
    "vnd.oasis.opendocument.base"
    "vnd.oasis.opendocument.database"
    "vnd.oasis.opendocument.text-template"
    "vnd.oasis.opendocument.spreadsheet-template"
    "vnd.oasis.opendocument.presentation-template"
    "vnd.oasis.opendocument.graphics-template"
    "vnd.oasis.opendocument.chart-template"
    "vnd.oasis.opendocument.formula-template"
    "vnd.oasis.opendocument.image-template"
    "vnd.oasis.opendocument.text-web"
  ])
```

### File manager

```nix "home-packages" +=
pcmanfm
lxmenu-data
shared-mime-info
```

```nix "xdg-mime" +=
{ "inode/directory" = "pcmanfm.desktop"; }
```

### Archive manager

File roller, when needing a terminal, doesn't look for kitty.
So we trick it wrapping kitty as gnome-terminal.

```nix "home-packages" +=
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

```nix "xdg-mime" +=
(subtypes "application" "org.gnome.FileRoller.desktop"
  [ "zip" "rar" "7z" "x-tar" "x-gtar" "gnutar" ])
```

### LaTeX

```nix "home-packages" +=
texlive.combined.scheme-full
```

### PDF

```nix "home-packages" +=
libsForQt5.okular
```

```nix "xdg-mime" +=
{ "application/pdf" = "okularApplication_pdf.desktop"; }
{ "image/vnd.djvu" = "okularApplication_pdf.desktop"; }
{ "image/x.djvu" = "okularApplication_pdf.desktop"; }
```

```nix "home-packages" +=
diffpdf
pdfmixtool
xournalpp
ocrmypdf tesseract
# masterpdfeditor4
```

### E-books

```nix "home-packages" +=
calibre
jmtpfs # For kindle
```

## Settings

```nix "home-packages" +=
pavucontrol # audio
pamixer
wdisplays   # screen
```

## Image and graphics

```nix "home-packages" +=
imv
```

```nix "xdg-mime" +=
(subtypes "image" "imv-folder.desktop"
  [ "png" "jpeg" "gif" "svg" "svg+xml" "tiff" "x-tiff" "x-dcraw" ])
```

### Drawing

```nix "home-packages" +=
gimp
kolourpaint
inkscape
```

### Scan

```nix "home-packages" +=
gnome.simple-scan
```

## Multimedia

```nix "home-packages" +=
mpv
rhythmbox
```

```nix "xdg-mime" +=
(subtypes "video" "umpv.desktop"
  [
    "avi" "msvideo" "x-msvideo"
    "mpeg" "x-mpeg" "mp4" "H264" "H265" "x-matroska"
    "ogg"
    "quicktime"
    "webm"
  ])
(subtypes "audio" "rhythmbox.desktop"
  [ "aac" "flac" "mpeg" "mpeg3" "ogg" "opus" "vorbis" "wav" ])
```

### Audio and music production

```nix "home-packages" +=
audacity
frescobaldi
musescore
```

Frescobaldi requires a midi synth:

```nix "home-config" +=
services.fluidsynth = {
  enable = true;
  soundService = "pipewire-pulse";
};
# disable autostart to save RAM
systemd.user.services.fluidsynth.Install.WantedBy = pkgs.lib.mkForce [];
```

```nix "home-packages" +=
qsynth
```

### Video editing and conversion

```nix "home-packages" +=
handbrake
mkvtoolnix
shotcut
# kdenlive
losslesscut-bin
obs-studio
```

## Internet

```nix "home-packages" +=
(tor-browser-bundle-bin.override {
  useHardenedMalloc = false;
})
```

### Downloads

```nix "home-packages" +=
clipgrab
qbittorrent
```

## Utilities

```nix "home-packages" +=
qalculate-gtk
sqlitebrowser
gnome.gnome-disk-utility
baobab # disk usage
tdesktop # Telegram
simplenote
ipscan
```

```nix "xdg-mime" +=
{ "x-scheme-handler/tg" = "telegramdesktop.desktop"; }
```

### Qemu

```nix "home-packages" +=
# qemu
```

Add user to the kvm group

```nix "user-groups" +=
#"kvm"
```

## Developing

```nix "home-packages" +=
cargo rustc clippy rustfmt
gdb
python3
(agda.withPackages (p: [ p.standard-library ]))
```

## *TODO* add:
- pnpm


<!--
## Unfree

**Warning**: these packages are not FOSS and so it is not guaranteed they don't harm the system.

```nix "home-packages-unfree" +=

```
 -->


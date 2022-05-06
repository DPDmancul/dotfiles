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
gnome.file-roller
```

```nix "xdg-mime" +=
(subtypes "application" "org.gnome.FileRoller.desktop"
  ["zip" "rar" "7z" "x-tar" "x-gtar" "gnutar" ])
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
blueman     # bluetooth
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
drawing
# kolourpaint
inkscape
```

### Scan

```nix "home-packages" +=
# TODO
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
sqlitebrowser
gnome.gnome-disk-utility
baobab # disk usage
tdesktop # Telegram
simplenote
ipscan
qemu
```

```nix "xdg-mime" +=
{ "x-scheme-handler/tg" = "telegramdesktop.desktop"; }
```

## Developing

```nix "home-packages" +=
cargo rustc clippy rustfmt
gdb
python3
agda
```

### LSP servers

Install LSP servers for Neovim

**TODO** remove when enabling Neovim config via Home-manager

```nix "home-packages" +=
rust-analyzer
texlab
nodePackages.bash-language-server
ccls
nodePackages.pyright
deno
nodePackages.yaml-language-server
nodePackages.vscode-css-languageserver-bin
nodePackages.vscode-html-languageserver-bin
nodePackages.vscode-json-languageserver
```

## *TODO* add:
- pnpm


<!--
## Unfree

**Warning**: these packages are not FOSS and so it is not guaranteed they don't harm the system.

```nix "home-packages-unfree" +=

```
 -->


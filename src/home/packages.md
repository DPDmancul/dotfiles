# User packages

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
"application/zip" = "org.gnome.FileRoller.desktop";
"application/rar" = "org.gnome.FileRoller.desktop";
"application/7z" = "org.gnome.FileRoller.desktop";
"application/*tar" = "org.gnome.FileRoller.desktop";
```

### File manager

```nix "home-packages" +=
pcmanfm
```

```nix "xdg-mime" +=
"inode/directory" = "pcmanfm.desktop";
```

### LaTeX

```nix "home-packages" +=
texlive.combined.scheme-medium
```

### PDF

```nix "home-packages" +=
libsForQt5.okular
```

```nix "xdg-mime" +=
"application/pdf" = "okularApplication_pdf.desktop";
```

```nix "home-packages" +=
diffpdf
pdfmixtool
xournalpp
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
"image/*" = "imv-folder.desktop";
"image/png" = "imv-folder.desktop";
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
lollypop
```

```nix "xdg-mime" +=
"video/*" = "umpv.desktop";
"video/mp4" = "umpv.desktop";
"audio/*" = "org.gnome.Lollypop.desktop";
```

### Audio and music production

```nix "home-packages" +=
audacity
denemo
musescore
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
```

```nix "xdg-mime" +=
"x-scheme-handler/tg" = "telegramdesktop.desktop";
```

## Developing

```nix "home-packages" +=
python3
```

## LSP servers

Servers for language server protocol integration in NeoVim

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

## TODO add:
- pnpm


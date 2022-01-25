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

### LaTeX

```nix "home-packages" +=
texlive.combined.scheme-basic
git-latexdiff
```

### PDF

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

## Image and graphics

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


## Downloads

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


## TODO add:
- pnpm
- LSP servers
  * rust-analyzer
  * texlab
  * bash-language-server
  * ccls
  * pyright
  * debo
  * yaml-language-server
  * vscode-css-languageserver
  * vscode-html-languageserver
  * vscode-json-languageserver


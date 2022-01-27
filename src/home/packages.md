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
texlive.combined.scheme-medium
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

## Developing

```nix "home-packages" +=
python3
```

## LSP servers

Servers for language server protocol integration in NeoVim

```nix "home-packages" +=
texlab
```

## TODO add:
- pnpm
- LSP servers
  * rust-analyzer
  * bash-language-server
  * ccls
  * pyright
  * debo
  * yaml-language-server
  * vscode-css-languageserver
  * vscode-html-languageserver
  * vscode-json-languageserver


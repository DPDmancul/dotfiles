# User packages

```nix "home-config" +=
home.packages = with pkgs; [
  <<<home-packages>>>
];
```

## Documents

```nix "home-packages" +=
libreoffice
```

```nix "home-config" +=
appDefaultForMimes = {
  "writer.desktop".application = [
    "vnd.oasis.opendocument.text"
    "msword"
    "vnd.ms-word"
    "vnd.openxmlformats-officedocument.wordprocessingml.document"
    "vnd.oasis.opendocument.text-template"
  ];
  "calc.desktop".application = [
    "vnd.oasis.opendocument.spreadsheet"
    "vnd.ms-excel"
    "vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "vnd.oasis.opendocument.spreadsheet-template"
  ];
  "impress.desktop".application = [
    "vnd.oasis.opendocument.presentation"
    "vnd.ms-powerpoint"
    "vnd.openxmlformats-officedocument.presentationml.presentation"
    "vnd.oasis.opendocument.presentation-template"
  ];
  "libreoffice.desktop".application = [
    "vnd.oasis.opendocument.graphics"
    "vnd.oasis.opendocument.chart"
    "vnd.oasis.opendocument.formula"
    "vnd.oasis.opendocument.image"
    "vnd.oasis.opendocument.text-master"
    "vnd.sun.xml.base"
    "vnd.oasis.opendocument.base"
    "vnd.oasis.opendocument.database"
    "vnd.oasis.opendocument.graphics-template"
    "vnd.oasis.opendocument.chart-template"
    "vnd.oasis.opendocument.formula-template"
    "vnd.oasis.opendocument.image-template"
    "vnd.oasis.opendocument.text-web"
  ];
};
```

### File manager

```nix "home-packages" +=
cinnamon.nemo
#pcmanfm lxmenu-data
shared-mime-info
```

```nix "homeconfig" +=
appDefaultForMimes."nemo.desktop" = "inode/directory";
```

Tell nemo to use kitty as terminal emulator

```nix "home-config" +=
dconf.settings."org/cinnamon/desktop/applications/terminal".exec = "kitty";
dconf.settings."org/cinnamon/desktop/default-applications/terminal".exec = "kitty";
```

Disable rendering of icons on desktop

```nix "home-config" +=
dconf.settings."org/nemo/desktop".show-desktop-icons = false;
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

```nix "home-config" +=
appDefaultForMimes."org.gnome.FileRoller.desktop".application = [ "zip" "rar" "7z" "x-tar" "x-gtar" "gnutar" ];
```

### LaTeX

```nix "home-packages" +=
texlive.combined.scheme-full
python3Packages.pygments
(pkgs.stdenvNoCC.mkDerivation rec {
  preferLocalBuild = true;
  pname = "textidote";
  version = "0.8.3";
  dontUnpack = true;
  dontConfigure = true;

  src = fetchurl {
    url = "https://github.com/sylvainhalle/${pname}/releases/download/v${version}/${pname}.jar";
    sha256 = "BIYswDrVqNEB+J9TwB0Fop+AC8qvPo53KGU7iupC7tk=";
  };

  buildPhase = ''
    cat > ${pname} << EOF
    #!/bin/sh
    exec ${openjdk_headless}/bin/java -jar $src \$@
  '';

  installPhase = ''
    install -Dm555 -t $out/bin ${pname}
  '';
})
```

### PDF

```nix "home-packages" +=
libsForQt5.okular
```

```nix "home-config" +=
appDefaultForMimes."okularApplication_pdf.desktop" = {
  application = "pdf";
  image = [ "vnd.djvu" "x.djvu" ];
};
```

```nix "home-packages" +=
diffpdf
pdfmixtool
xournalpp
ocrmypdf tesseract
unfree.masterpdfeditor4
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

```nix "home-config" +=
appDefaultForMimes."imv-folder.desktop".image = [ "png" "jpeg" "gif" "svg" "svg+xml" "tiff" "x-tiff" "x-dcraw" ];
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
ffmpeg
```

```nix "home-config" +=
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

### Audio and music production

```nix "home-packages" +=
audacity
lilypond # frescobaldi
# denemo
musescore
```

Lilypond requires a midi synth:

<!--
```nix "home-config-comment" +=
services.fluidsynth = {
  enable = true;
  soundService = "pipewire-pulse";
};
# disable autostart to save RAM
systemd.user.services.fluidsynth.Install.WantedBy = pkgs.lib.mkForce [];
```
-->

```nix "home-packages" +=
(symlinkJoin {
  name = "fluidsynth";
  paths = [ fluidsynth ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/fluidsynth \
      --add-flags "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
  '';
})
qsynth
```

### Video editing and conversion

```nix "home-packages" +=
handbrake
mkvtoolnix
# shotcut
kdenlive
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
libfaketime
```

```nix "home-config" +=
appDefaultForMimes."telegramdesktop.desktop" = "x-scheme-handler/tg";
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


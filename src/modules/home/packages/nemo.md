# Nemo (file manager)

```nix modules/home/packages/nemo.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../xdg.nix
  ];

  home.packages = with pkgs; [
    nemo
    shared-mime-info
    <<<modules/home/packages/nemo-packages>>>
  ];

  appDefaultForMimes."nemo.desktop" = "inode/directory";

  <<<modules/home/packages/nemo>>>
}
```

Tell nemo to use kitty as terminal emulator

```nix "modules/home/packages/nemo" +=
dconf.settings."org/cinnamon/desktop/applications/terminal".exec = "kitty";
dconf.settings."org/cinnamon/desktop/default-applications/terminal".exec = "kitty";

```
Disable rendering of icons on desktop

```nix "modules/home/packages/nemo" +=
dconf.settings."org/nemo/desktop".show-desktop-icons = false;
```

## Thumbnails

Enable HEIC thumbnails (TODO: not working)

```nix "modules/home/packages/nemo-packages" +=
libheif
libheif.out
```

Enable video thumbnails

```nix "modules/home/packages/nemo-packages" +=
ffmpegthumbnailer
```

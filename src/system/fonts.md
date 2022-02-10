# Fonts

```nix "config" +=
fonts.fonts = with pkgs; [
  (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
];
```

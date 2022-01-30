# freedesktop.org

```nix "home-config" +=
xdg = {
  enable = true;
  <<<xdg-config>>>
};
```

## User directories

Create standard user directories

```nix "xdg-config" +=
userDirs = {
  enable = true;
  createDirectories = true;
};
```

## Default applications

```nix "xdg-config" +=
mimeApps = {
  enable = true;
  defaultApplications = lib.zipAttrsWith
    (_: values: values)
    (let
      subtypes = type: program: subt:
        builtins.listToAttrs (builtins.map
          (x: {name = type + "/" + x; value = program; })
          subt);
    in [
      { "text/plain" = "nvim.desktop"; }
      <<<xdg-mime>>>
    ]);
};
```


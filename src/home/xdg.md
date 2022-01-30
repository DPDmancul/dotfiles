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
  defaultApplications = {
    "text/plain" = "nvim.desktop";
    <<<xdg-mime>>>
  };
};
```


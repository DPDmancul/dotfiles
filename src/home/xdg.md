# freedesktop.org

```nix "home-config" +=
xdg = {
  enable = true;
  <<<xdg-config>>>
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


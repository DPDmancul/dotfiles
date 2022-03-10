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
```

I will write a list of sets, the following will flat it in a set

```nix "xdg-config" +=
  defaultApplications = lib.zipAttrsWith
    (_: values: values)
```

I use an helper function (`subtypes`) to avoid rewriting the same rule multiple times, changing only the subtype.

```nix "xdg-config" +=
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

## Polkit

```sh "home-config" +=
systemd.user.services.polkit-agent = {
  Unit = {
    Description = "Runs polkit authentication agent";
    PartOf = "graphical-session.target";
  };

  Install = {
    WantedBy = ["graphical-session.target"];
  };

  Service = {
    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    RestartSec = 5;
    Restart = "always";
  };
};
```


# freedesktop.org

```nix modules/home/xdg.nix
{ config, pkgs, lib, ... }:
{
  config.xdg = {
    enable = true;
    <<<modules/home/xdg-config>>>
  };
  <<<modules/home/xdg>>>
}
```

## User directories

Create standard user directories

```nix "modules/home/xdg-config" +=
userDirs = {
  enable = true;
  createDirectories = true;

  # do not create useless folders
  desktop = "$HOME";
  publicShare = "$HOME/.local/share/Public";
  templates = "$HOME/.local/share/Templates";
};
```

## Default applications

Add an option for inverse defaultApplications declaration: the mimes are assigned to the program.

```nix "modules/home/xdg" +=
options.appDefaultForMimes = with lib; let
  concatMapAttrsToList = f: attrs:
    concatMap (name: f name attrs.${name}) (attrNames attrs);
  strListOrStr = with types;
    coercedTo str toList (listOf str);
  strListOrStrOrAttrsOfSelf = with types;
    coercedTo (attrsOf strListOrStr)
      (concatMapAttrsToList (type: subtypes: map (subtype: "${type}/${subtype}") (toList subtypes)))
      strListOrStr;
in
mkOption {
  type = types.attrsOf strListOrStrOrAttrsOfSelf;
  default = { };
  example = literalExpression ''
    {
      "nvim.desktop" = "text/plain";
      # or "nvim.desktop".text = "plain";
      "writer.desktop".application = [
        "vnd.oasis.opendocument.text"
        "msword"
        "vnd.ms-word"
        "vnd.openxmlformats-officedocument.wordprocessingml.document"
        "vnd.oasis.opendocument.text-template"
      ];
    }
  '';
};
```

```nix "modules/home/xdg-config" +=
mimeApps = {
  enable = true;
  defaultApplications = with lib; zipAttrs (mapAttrsToList
    (app: mimes: genAttrs mimes (const app))
    config.appDefaultForMimes);
};
```

## Polkit

```nix "home-config" +=
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


# Login manager

Use greetd as login manager for Sway

```nix "config" +=
services.greetd = {
  enable = true;
  settings = let
    sway-run = pkgs.writeShellScript "sway-run" ''
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway

      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

      systemd-cat --identifier=sway dbus-run-session sway $@
    '';
  in {
    <<<greetd-sessions>>>
  };
};
```

## Default session

Run agreety as greeter

```nix "greetd-sessions" +=
default_session = {
  command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${sway-run}";
  user = "greeter";
};
```

## Initial session

Start Sway without login at startup: being the drive encrypted, a password was already asked

```nix "greetd-sessions" +=
initial_session = {
  command = sway-run;
  user = "dpd-";
};
```


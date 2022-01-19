# Login manager

Use greetd as login manager for Sway

```nix "config" +=
services.greetd = {
  enable = true;
  settings = {
    <<<greetd-sessions>>>
  };
};
```

## Default session

Run agreety as greeter

```nix "greetd-sessions" +=
default_session = {
  command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
  user = "greeter";
};
```

## Initial session

Start Sway without login at startup: being the drive encrypted, a password was already asked

```nix "greetd-sessions" +=
initial_session = {
  command = "${pkgs.sway}/bin/sway";
  user = "dpd-";
};
```


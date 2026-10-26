# Canaries

Get notified if someone uses a canary token found in your computer.

```nix modules/home/canaries.nix
{ config, pkgs, lib, ... }:
{
  <<<modules/home/canaries>>>
}
```

## SSH host

```nix "modules/home/canaries" +=
programs.ssh.settings."hg1aose4c9ucmyloxwqhqlllv.canarytokens.com" = {
  User = "admin";
};
```

## AWS credentials

The secret is split, using string concatenation, since I don't want to be notified
each time someone scrapes my config 😉

```nix "modules/home/canaries" +=
home.file.".aws/credentials".text = ''
  [default]
  aws_access_key_id = AKIARBMXDLWTHFECOLG3
  aws_secret_access_key = 4t/k9LQuHw10E7Xd+''+''ar+b7AYS+c2GA8MjSymM0XJ
  output = json
  region = us-east-2
'';
```


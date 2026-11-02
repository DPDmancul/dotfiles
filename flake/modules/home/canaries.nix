{ config, pkgs, lib, ... }:
{
  programs.ssh.settings."${"hg1aose4c9ucmyloxwqh"+"qlllv.canarytokens.c"+"om"}" = {
    User = "admin";
  };
  home.file.".aws/credentials".text = ''
    [default]
    aws_access_key_id = AKIARBMX''+''DLWTHFECOLG3
    aws_secret_access_key = 4t/k9LQuHw10E7Xd+''+''ar+b7AYS+c2GA8MjSymM0XJ
    output = json
    region = us-east-2
  '';
}

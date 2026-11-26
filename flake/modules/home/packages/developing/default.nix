{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    ghidra
  ];

  home.file.".local/include/ghidra".source = pkgs.symlinkJoin {
    name = "ghidra-c-headers";
    paths = [
      "${pkgs.glibc.dev}/include"
      "${pkgs.linuxHeaders}/include"
      "${pkgs.openssl.dev}/include"
      "${pkgs.gcc-unwrapped}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc-unwrapped.version}/include"
    ];
  };
}

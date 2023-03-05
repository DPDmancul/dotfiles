self: super: {
  lib = super.lib.extend (self: super:
    import ../lib.nix { lib = self; }
  );
}

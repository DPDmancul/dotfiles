final: prev: {
  lib = prev.lib.extend (self: super:
    import ../lib.nix { lib = self; }
  );
}

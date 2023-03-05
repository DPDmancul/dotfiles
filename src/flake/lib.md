# Custom lib

```nix lib.nix
{ lib }: with lib;
{
```

Generate an attr set from a list

`concatMapToAttrs :: (a -> AttrSet b) -> [a] -> AttrSet b`

```nix lib.nix +=
  concatMapToAttrs = f: flip pipe [ (map f) (foldl' mergeAttrs { }) ];
```

```nix lib.nix +=
}
```

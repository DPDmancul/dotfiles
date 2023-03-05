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

Generate an attr set from a list of attr sets

`concatMapPairToAttrs :: (String -> a -> AttrSet b) -> [AttrSet a] -> AttrSet b`

```nix lib.nix +=
concatMapPairToAttrs = f: concatMapToAttrs (concatMapAttrs f);
```
```nix lib.nix +=
}
```

{ lib }: with lib;
{
  concatMapToAttrs = f: flip pipe [ (map f) (foldl' mergeAttrs { }) ];
concatMapPairToAttrs = f: concatMapToAttrs (concatMapAttrs f);
}

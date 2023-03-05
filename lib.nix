{ lib }: with lib;
{
  concatMapToAttrs = f: flip pipe [ (map f) (foldl' mergeAttrs { }) ];
}

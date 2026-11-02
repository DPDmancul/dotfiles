# mpv (player)

```nix modules/home/packages/mpv.nix
{ config, pkgs, lib, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      <<<modules/home/packages/mpv-config>>>
    };
    scripts = with pkgs.mpvScripts; [
      <<<modules/home/packages/mpv-scripts>>>
    ];
  };

  <<<modules/home/packages/mpv>>>
}
```

## Default for mimes


```nix "modules/home/packages/mpv" +=
appDefaultForMimes."umpv.desktop" = {
  video = [
    "avi" "msvideo" "x-msvideo"
    "mpeg" "x-mpeg" "mp4" "H264" "H265" "x-matroska"
    "ogg"
    "quicktime"
    "webm"
  ];
  audio = [
    "aac" "flac"
    "mpeg" "mpeg3" # mp3
    "ogg" "vorbis" "opus" "x-opus+ogg"
    "wav" "x-wav"
    "audio/x-ms-wma"
  ];
};
```

## Config

### OSD


```nix "modules/home/packages/mpv-config" +=
osd-scale-by-window = false;
```

### Language priorities

Prefer Italian, using English as fallback

```nix "modules/home/packages/mpv-config" +=
alang = ["it" "ita" "en" "eng"];
```

Show only forced subtitles

```nix "modules/home/packages/mpv-config" +=
slang = ["it" "ita" "en" "eng"];
subs-fallback-forced = "always";
subs-fallback = false;
```

## Scripts

### Skip silence

```nix "modules/home/packages/mpv-scripts" +=
skipsilence
```


{ config, pkgs, lib, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      osd-scale-by-window = false;
      alang = ["it" "ita" "en" "eng"];
      slang = ["it" "ita" "en" "eng"];
      subs-fallback-forced = "always";
      subs-fallback = false;
    };
    scripts = with pkgs.mpvScripts; [
      skipsilence
    ];
  };

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
}

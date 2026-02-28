{ config, pkgs, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;

  cfg = config.programs.fish.tide;
in
{
  options.programs.fish.tide = {
    enable = mkEnableOption "Wheter to enable tide, a fish prompt.";

    src = mkOption {
      default = pkgs.fishPlugins.tide.src;
      description = "The tide source to use.";
      type = types.path;
    };

    style = mkOption {
      default = "lean";
      description = "The base style.";
      example = [
        "classic"
        "lean"
        "rainbow"
      ];
      type = types.str;
    };

    trueColors = mkOption {
      default = true;
      description = "Wheter to enable true colors or use only 16 colors.";
      example = false;
      type = types.bool;
    };

    config = mkOption {
      default = {};
      description = "Configuration values. See <https://github.com/IlanCosman/tide/wiki/Configuration>.";
      example = {
        prompt = {
          add_newline_before = "true";
          min_cols = "40";
        };
        left_prompt.prefix = ">";
      };
      type = with types; attrsOf (attrsOf str);
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      plugins = [
        {
          name = "tide";
          src = cfg.src;
        }
      ];
      interactiveShellInit = let
        parseConfig = file:
          let
            content = lib.readFile file;
            lines = lib.splitString "\n" content;
            kvPairs = lib.concatMap (line:
              let
                parts = lib.splitString " " line;
              in lib.optional (lib.length parts > 0)
              {
                name = lib.head parts;
                value = lib.concatStringsSep " " (lib.tail parts);
              }
            ) lines;
          in
            lib.listToAttrs kvPairs;
        styleFile = if cfg.trueColors then cfg.style else "${cfg.style}_16color";
        iconsConfig = parseConfig "${cfg.src}/functions/tide/configure/icons.fish";
        styleConfig = parseConfig "${cfg.src}/functions/tide/configure/configs/${styleFile}.fish";
        userConfig = lib.concatMapAttrs
          (header: lib.mapAttrs' (name: value: { name = "${header}_${name}"; inherit value; }))
          cfg.config;
      in
        lib.concatMapAttrsStringSep
          "\n"
          (name: value: "set -x tide_${name} ${value}")
          (iconsConfig // styleConfig // userConfig);
    };
  };
}

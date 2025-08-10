{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.utils.fonts;
in {
  options = {
    utils.fonts = let
      font = lib.types.submodule {
        options = {
          family = lib.mkOption {type = lib.types.str;};
          weight = lib.mkOption {type = lib.types.str;};
          size = lib.mkOption {type = lib.types.int;};
          package = lib.mkOption {type = lib.types.package;};
        };
      };
    in {
      describeFont = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
      };
      # for text in GTK applications
      primary = lib.mkOption {type = font;};
      # for other system things
      secondary = lib.mkOption {type = font;};
      # for coding and stuff
      monospace = lib.mkOption {type = font;};
    };
  };

  config = {
    utils.fonts = {
      # helper function to convert a font to a text representation
      describeFont = font: "${font.family} ${font.weight} ${toString font.size}";

      primary = {
        family = "Cozette";
        weight = "Medium";
        size = 13;
        package = pkgs.cozette;
      };
      secondary = {
        family = "creep";
        weight = "Bold";
        size = 12;
        package = pkgs.creep;
      };
      monospace = {
        family = "Cozette";
        weight = "Medium";
        size = 13;
        package = pkgs.cozette;
      };
    };

    # enabling fontconfig should regenerate cache when new font packages are added
    fonts.fontconfig.enable = true;

    home.packages = [
      cfg.primary.package
      cfg.secondary.package
      cfg.monospace.package
    ];
  };
}

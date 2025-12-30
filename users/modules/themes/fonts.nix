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
          size = lib.mkOption {type = lib.types.number;};
          package = lib.mkOption {type = lib.types.package;};
        };
      };
      fontset = lib.types.submodule {
        options = {
          # for text in GTK applications
          primary = lib.mkOption {type = font;};
          # for other system things
          secondary = lib.mkOption {type = font;};
          # for coding and stuff
          monospace = lib.mkOption {type = font;};
          # for symbols while coding
          symbols = lib.mkOption {type = font;};
        };
      };
    in {
      describeFont = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
      };
      xorg = lib.mkOption {type = fontset;};
      wayland = lib.mkOption {type = fontset;};
      active = lib.mkOption {type = fontset;};
    };
  };

  config = {
    utils.fonts = {
      # helper function to convert a font to a text representation
      describeFont = font: "${font.family} ${font.weight} ${toString font.size}";

      # I like to use different fonts on xorg and wayland, since wayland
      # seems to struggle with bitmap fonts
      xorg = {
        primary = {
          family = "Terminus";
          weight = "Regular";
          size = 11;
          package = pkgs.terminus_font;
        };
        secondary = {
          family = "creep";
          weight = "Bold";
          size = 12;
          package = pkgs.creep;
        };
        monospace = {
          family = "Terminus";
          weight = "Regular";
          size = 11;
          package = pkgs.terminus_font;
        };
        symbols = {
          family = "BitmapGlyphs";
          weight = "Regular";
          size = 11;
          package = pkgs.bitmap-glyphs-12;
        };
      };

      wayland = {
        primary = {
          family = "ProggyVector";
          weight = "Regular";
          size = 9; # points
          package = pkgs.callPackage ./proggyvector.nix {};
        };
        secondary = {
          family = "creep";
          weight = "Bold";
          size = 12;
          package = pkgs.creep;
        };
        monospace = {
          family = "ProggyVector";
          weight = "Regular";
          size = 9; # points
          package = pkgs.callPackage ./proggyvector.nix {};
        };
        symbols = {
          family = "BitmapGlyphs";
          weight = "Regular";
          size = 11;
          package = pkgs.bitmap-glyphs-12;
        };
      };

      active =
        if config.modules.desktops.primary_display_server == "xorg"
        then cfg.xorg
        else cfg.wayland;
    };

    # enabling fontconfig should regenerate cache when new font packages are added
    fonts.fontconfig.enable = true;

    # for terminal and such, prefer monospace font followed by symbol font
    fonts.fontconfig.defaultFonts.monospace = [
      cfg.active.monospace.family
      cfg.active.symbols.family
    ];

    home.packages = [
      cfg.active.primary.package
      cfg.active.secondary.package
      cfg.active.monospace.package
      cfg.active.symbols.package
    ];
  };
}

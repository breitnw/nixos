{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.gtk;
in {
  imports = [
    ./gtk3-classic
  ];

  options = {
    modules.gtk = {
      customGTKTheme = lib.mkOption {
        description = ''
          The custom GTK theme to use. If null, a greybird GTK theme is
          automatically generated based on the nix-colors scheme.
        '';
        default = null;
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            name = lib.mkOption {type = lib.types.str;};
            package = lib.mkOption {type = lib.types.package;};
          };
        });
      };
    };
  };

  config = {
    programs.niri.settings.cursor = lib.mkIf config.modules.desktops.wayland.enable {
      theme = config.home.pointerCursor.name;
      # TODO different size/cursor for xorg and wayland
      size = config.home.pointerCursor.size;
    };
    home.pointerCursor = {
      gtk.enable = true;
      sway.enable = true;
      x11.enable = true;
      name = "Hackneyed-Dark";
      package = pkgs.hackneyed-x11-cursors;
      size = 24;
    };
    gtk = {
      enable = true;
      iconTheme = {
        package = inputs.buuf-icon-theme.packages.${pkgs.stdenv.hostPlatform.system}.default;
        name = "buuf-icon-theme";
      };

      # set the GTK theme according to the color scheme, unless it is overridden
      theme =
        if (isNull cfg.customGTKTheme)
        then {
          package = pkgs.greybird-with-accent config.colorscheme.palette.base0D;
          name =
            if config.colorScheme.variant == "dark"
            then "greybird-generated-dark"
            else "greybird-generated";
        }
        else cfg.customGTKTheme;

      font = let
        primary = config.utils.fonts.active.primary;
      in {
        inherit (primary) package size;
        name = primary.family;
      };
    };
  };
}

{
  config,
  lib,
  inputs,
  pkgs,
  ...
} @ args: let
  cfg = config.modules.themes;
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./config-loader.nix
    ./mustache.nix # for substituting the theme in config files
  ];

  options = {
    modules.themes = {
      themeName =
        lib.mkOption {description = "The base16 system theme to use";};
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
    # unless otherwise customized, grab the scheme from nix-colors
    colorScheme =
      lib.mkDefault
      (lib.optionalAttrs (lib.hasAttr cfg.themeName inputs.nix-colors.colorSchemes)
        inputs.nix-colors.colorSchemes.${cfg.themeName});

    # configure the GTK theme with the gtk attrset
    gtk.enable = true;

    # set the GTK theme according to the color scheme, unless it is overridden
    gtk.theme =
      if (isNull cfg.customGTKTheme)
      then {
        package = pkgs.greybird-with-accent config.colorscheme.palette.base0D;
        name =
          if config.colorScheme.variant == "dark"
          then "greybird-generated-dark"
          else "greybird-generated";
      }
      else cfg.customGTKTheme;
  };
}

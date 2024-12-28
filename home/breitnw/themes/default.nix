{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.themes;
in

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./loaded.nix # import the loaded theme
  ];

  options = {
    themes.themeName = lib.mkOption {
      description = "The system theme to use";
      default = "Adwaita";
    };
    themes.customGTKTheme = lib.mkOption {
      description = ''
        The custom GTK theme to use. If null, a materia GTK theme is automatically
        generated based on the nix-colors scheme.
      '';
      default = null;
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
          };
          package = lib.mkOption {
            type = lib.types.package;
          };
        };
      });
    };
  };

  config = {
    # we configure the GTK theme with the gtk attrset
    gtk.enable = true;
    # set the GTK theme according to the color scheme, unless it is overridden
    gtk.theme = if (isNull cfg.customGTKTheme) then {
      package =
        let nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
        in nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
      name = config.colorScheme.slug;
    } else cfg.customGTKTheme;
  };
}

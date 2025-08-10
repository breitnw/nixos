{
  config,
  lib,
  inputs,
  ...
} @ args: let
  cfg = config.modules.themes;
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./config-loader.nix
    ./mustache.nix # for substituting the theme in config files
    ./fonts.nix # utilities for font configuration
  ];

  options = {
    modules.themes = {
      themeName =
        lib.mkOption {description = "The base16 system theme to use";};
    };
  };

  config = {
    # unless otherwise customized, grab the scheme from nix-colors
    colorScheme =
      lib.mkDefault
      (lib.optionalAttrs (lib.hasAttr cfg.themeName inputs.nix-colors.colorSchemes)
        inputs.nix-colors.colorSchemes.${cfg.themeName});
  };
}

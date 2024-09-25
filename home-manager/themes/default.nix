{ lib, config, pkgs, ... }:

let
  themes = {
    "Adwaita" = ./adwaita.nix;
    "Gruvbox" = ./gruvbox.nix;
    # ...
  };
in {
  options = {
    theme = {
      name = lib.mkOption {
        description = "The name of the global theme to use.";
        default = "Adwaita";
        type = lib.types.enum (builtins.attrNames themes);
      };
    };
  };

  # Load
  config = lib.mkMerge (lib.mapAttrsToList
    (name: modPath: lib.mkIf (config.theme.name == name)
      (import modPath pkgs))
    themes);
}

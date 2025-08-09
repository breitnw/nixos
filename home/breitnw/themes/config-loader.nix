# Loads configuration for the selected color scheme. Configuration is loaded if
# there is a file present in the ./mods directory named {themeName}.nix.
#
# mkMerge is necessary for this approach. Directly importing the theme defined
# by cfg.themeName will lead to infinite recursion.
{
  config,
  lib,
  ...
} @ args: let
  cfg = config.modules.themes;
  filename = "${cfg.themeName}.nix";
in
  lib.mkMerge
  (map (path: lib.mkIf (baseNameOf path == filename) (import path args))
    (lib.fileset.toList ./custom))

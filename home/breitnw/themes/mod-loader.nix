{ config, lib, pkgs, ... }@args:

# Loads modifications for the selected color scheme. Modifications are loaded if
# there is a file present in the mods/ directory named {themeName}.nix.

let
  cfg = config.modules.themes;
  filename = "${cfg.themeName}.nix";

in lib.mkMerge (map (path: lib.mkIf (baseNameOf path == filename) (import path args))
  (lib.fileset.toList ./mods))

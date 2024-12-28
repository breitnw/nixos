# creates an attribute set for the loaded theme

{ config, lib, pkgs, ... } @ args:

let
  themes = {
    "Zenburn" = ./sets/zenburn.nix;
    "Gruvbox" = ./sets/gruvbox.nix;
    "Horizon" = ./sets/horizon.nix;
    # ...
  };
in

lib.mkMerge (lib.mapAttrsToList
  (name: modPath: lib.mkIf (config.themes.themeName == name)
    (import modPath args))
  themes)

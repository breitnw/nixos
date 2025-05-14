{ lib, ... }:

# TODO combine mods into a single attrset

{
  modules.themes.customSchemes = lib.listToAttrs (map (path: {
    name = lib.removeSuffix ".nix" (baseNameOf path);
    value = import path;
  }) (lib.fileset.toList ./custom));
}

{ lib, ... }:

{
  options = {
    keybinds = lib.mkOption {
      description = ''
        A standardized set of global key bindings.
      '';
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    };
  };
  config = {
    keybinds = builtins.fromTOML (builtins.readFile ./keybinds.toml);
  };
}

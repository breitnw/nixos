{ lib, ... }:

{
  options = {
    utils.keybinds = lib.mkOption {
      description = ''
        A standardized set of global key bindings.
      '';
      type = lib.types.attrs;
    };
  };
  config = {
    utils.keybinds = builtins.fromTOML (builtins.readFile ./keybinds.toml);
  };
}

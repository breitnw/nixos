{ lib, config, ... }:

with config.utils.keybinds.xfce;
let
  # function to swap names and values in an attrset
  invertAttrs = lib.mapAttrs' (name: value: (lib.nameValuePair value name));
  # exo-commands: launch exo applications
  exo-commands =
    lib.mapAttrs (keystroke: cmd: "exo-open --launch ${cmd}") (invertAttrs exo);
in {
  # keybinds to (usually) launch apps with commands
  commands.custom = exo-commands // {
    ${custom.emacs} = "emacsclient --create-frame --alternate-editor=''";
    ${custom.find-app} = "xfce4-appfinder";
  };
  # keybinds to navigate xfwm4
  xfwm4.custom = invertAttrs xfwm4;
}

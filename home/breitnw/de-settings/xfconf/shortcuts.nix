{
  lib,
  config,
  ...
}:
with config.utils.keybinds.xfce; let
  # function to swap names and values in an attrset
  invertAttrs = lib.mapAttrs' (name: value: (lib.nameValuePair value name));
  # exo-commands: launch exo applications
  exo-commands =
    lib.mapAttrs (keystroke: cmd: "exo-open --launch ${cmd}") (invertAttrs exo);
in {
  # keybinds to (usually) launch apps with commands
  commands.custom =
    exo-commands
    // {
      ${custom.calendar} = "alacritty -o 'cursor.style=\"Beam\"' -e ikhal";
      ${custom.music} = "alacritty -o 'window.dimensions.columns = 70' -o 'window.dimensions.lines=22' -e rmpc";
      ${custom.emacs} = "emacsclient --create-frame";
      ${custom.find-app} = "xfce4-appfinder";
      ${custom.autorandr} = "autorandr --change";
    };
  # keybinds to navigate xfwm4
  xfwm4.custom = invertAttrs xfwm4;
}

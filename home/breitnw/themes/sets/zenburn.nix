{ lib, config, inputs, ... }:

{
  # nix-colors
  colorScheme = inputs.nix-colors.colorSchemes.zenburn;

  # TODO firefox

  # set emacs theme
  modules.doom.theme = "doom-zenburn";
}

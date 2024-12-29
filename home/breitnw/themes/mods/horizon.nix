{ inputs, ... }:

{
  # nix-colors
  colorScheme = inputs.nix-colors.colorSchemes.horizon-dark;

  # doom theme
  modules.doom.theme = "doom-horizon";
}

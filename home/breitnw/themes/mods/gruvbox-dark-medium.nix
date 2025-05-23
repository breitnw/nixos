{ pkgs, inputs, ... }:

{
  # custom GTK theme, since the colors are too vibrant for my taste
  # modules.themes.customGTKTheme = {
  #   package = pkgs.gruvbox-dark-gtk;
  #   name = "gruvbox-dark";
  # };

  # sourcerer is a good doom theme to match gruvbox (even though
  # there's gruvbox too)
  modules.doom.theme = "doom-sourcerer";
}

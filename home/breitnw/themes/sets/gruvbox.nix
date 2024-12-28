{ pkgs, inputs, ... }:

{
  # nix-colors
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  # custom GTK theme, since the colors are too vibrant for my taste
  themes.customGTKTheme = {
    package = pkgs.gruvbox-dark-gtk;
    name = "gruvbox-dark";
  };

  # since the GTK theme produces a weird desktop text color on XFCE
  modules.desktops.xfce.overrideDesktopTextColor = true;

  # sourcerer is a good doom theme to match gruvbox (even though
  # there's gruvbox too)
  # modules.doom.theme = "doom-sourcerer";
}

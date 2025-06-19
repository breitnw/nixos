{
  pkgs,
  inputs,
  ...
}:
# settings for the desktop environment, window manager,
# compositor... y'know, the works.
{
  imports = [./xfconf ./gtk3-classic ./picom.nix];
}

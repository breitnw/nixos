{
  pkgs,
  inputs,
  ...
}:
# settings for the desktop environment, window manager,
# compositor... y'know, the works.
{
  imports = [./xfce ./sway ./gtk3-classic];
}

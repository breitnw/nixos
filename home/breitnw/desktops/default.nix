{
  pkgs,
  inputs,
  lib,
  ...
}:
# settings for the desktop environment, window manager,
# compositor... y'know, the works.
{
  options = {
    modules.desktops = {
      primary_display_server = lib.mkOption {
        type = lib.types.enum ["xorg" "wayland"];
      };
    };
  };

  config = {
    modules.desktops.primary_display_server = "wayland";
  };

  imports = [./xfce ./sway ./gtk ./niri];
}

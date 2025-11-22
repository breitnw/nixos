{lib, ...}:
# settings for the desktop environment, window manager,
# compositor... y'know, the works.
{
  options = {
    modules.desktops = {
      # defines fonts and stuff
      primary_display_server = lib.mkOption {
        type = lib.types.enum ["xorg" "wayland"];
      };
      # enable/disable specific desktop environments and related packages
      wayland.enable = lib.mkEnableOption "enable Wayland desktop environments";
      xorg.enable = lib.mkEnableOption "enable X.org desktop environments";
    };
  };

  config.modules.desktops = {
    primary_display_server = "wayland";
    wayland.enable = true;
    xorg.enable = false;
  };

  imports = [./xorg ./wayland ./gtk];
}

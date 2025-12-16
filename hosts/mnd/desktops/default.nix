{
  pkgs,
  lib,
  ...
}:
# Desktop environment support modules
{
  options = {
    desktops.xorg.enable = lib.mkEnableOption "whether to enable x.org desktop environments";
    desktops.wayland.enable = lib.mkEnableOption "whether to enable wayland desktop environments";
  };
  config = {
    services.xserver.displayManager.startx.enable = true;

    # this seems to improve the startup experience, but idk why
    # but it also causes apps to randomly hang i think :(
    # services.xserver.displayManager.startx.generateScript = true;

    # use tuigreet as the display manager (actually idek if that's the right
    # terminology or if tuigreet is something else entirely but it does the
    # same job so that's what I'm gonna call it)
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.tuigreet}/bin/tuigreet \
              --remember-session \
              --user-menu \
              --asterisks \
              --time
          '';
        };
      };
    };

    # Configure the enabled desktop environments
    desktops.xfce.enable = true;

    # Needed if we're using Wayland
    security.polkit.enable = true;

    # enable niri
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;
    programs.niri.useNautilus = false; # GET THE GNOMES AWAY FROM ME

    # enable sway
    programs.sway.enable = true;
  };

  imports = [
    ./xfce.nix
  ];
}

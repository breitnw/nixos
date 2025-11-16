{
  pkgs,
  lib,
  ...
}:
# Desktop environment support modules
{
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
    desktops.sway.enable = true;

    programs.niri.enable = true;
  };

  imports = [
    ./xfce.nix
    ./sway.nix
  ];
}

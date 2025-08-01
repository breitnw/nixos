{pkgs, ...}:
# Desktop environment support modules
{
  config = {
    services.xserver.displayManager.startx.enable = true;

    # use tuigreet as the display manager (actually idek if that's the right
    # terminology or if tuigreet is something else entirely but it does the
    # same job so that's what I'm gonna call it)
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
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
    desktops.sway.enable = false;
  };

  imports = [
    ./xfce.nix
    ./sway.nix
  ];
}

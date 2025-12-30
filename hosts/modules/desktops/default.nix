{
  pkgs,
  lib,
  config,
  ...
}:
# Desktop environment support modules
# TODO needs cleanup! ideally sync desktop config with home-manager; if not, at
# least consolidate display protocol and desktop environment options
let
  cfg = config.modules.desktops;
in {
  imports = [
    ./dbus.nix
  ];

  options = {
    modules.desktops = {
      # enable/disable specific desktop environments and related packages
      wayland.enable = lib.mkEnableOption "enable Wayland desktop environments";
      xorg.enable = lib.mkEnableOption "enable X.org desktop environments";
    };
  };

  config = {
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

    # ALL DESKTOPS =============================================================

    security.polkit.enable = true;

    services.graphical-desktop.enable = true;

    programs.dconf.enable = true;

    # from https://discourse.nixos.org/t/xdg-desktop-portal-gtk-desktop-collision/35063
    # xdg desktop portals expose d-bus interfaces for xdg file access
    # are needed by some containerized apps like firefox.
    xdg.portal = {
      enable = true;
      wlr.enable = cfg.wayland.enable;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = let wayland-conf = {
        default = [ "gtk" ];
        #... except for the ScreenCast, Screenshot and Secret
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        # ignore inhibit bc gtk portal always returns as success,
        # despite sway/the wlr portal not having an implementation,
        # stopping firefox from using wayland idle-inhibit
        "org.freedesktop.impl.portal.Inhibit" = "none";
      }; in lib.mkIf cfg.wayland.enable {
        niri = wayland-conf;
        sway = wayland-conf;
      };
      configPackages = [
        (lib.mkIf cfg.wayland.enable pkgs.niri)
        (lib.mkIf cfg.xorg.enable pkgs.xfce.xfce4-session)
      ];
    };

    # XORG =====================================================================

    services.xserver = {
      enable = cfg.xorg.enable;
      # enable startx to start X server sessions
      displayManager.startx.enable = cfg.xorg.enable;
      # add XFCE to the display manager
      desktopManager.session = lib.mkIf cfg.xorg.enable [{
        name = "xfce";
        prettyName = "Xfce";
        desktopNames = [ "XFCE" ];
        bgSupport = true;
        start = ''
          ${pkgs.runtimeShell} ${pkgs.xfce.xfce4-session.xinitrc} &
          waitPID=$!
        '';
      }];
      # update the DBus environment after launching the session
      updateDbusEnvironment = cfg.xorg.enable;
    };

    # make sessions visible in display manager
    services.displayManager.sessionPackages = with pkgs;
      lib.mkIf cfg.wayland.enable [ niri sway ];

    # Window manager only sessions (unlike DEs) don't handle XDG
    # autostart files, so force them to run the service
    services.xserver.desktopManager.runXdgAutostartIfNone = true;
  };
}

{pkgs, ...}: {
  imports = [
    ./xfconf
    ./autorandr.nix
    ./picom.nix
  ];

  home.packages = with pkgs; [
    # xfce4-session binary is owned by home-manager
    xfce.xfce4-session

    # xfconf relies on system dbus, so it's enabled in
    # hosts/mnd/desktops/dbus.nix

    glib # for gsettings
    gtk3.out # gtk-update-icon-cache

    desktop-file-utils
    shared-mime-info
    xdg-user-dirs # Needed by Xfce's xinitrc script

    xfce.exo # default applications
    xfce.garcon # menu support
    xfce.libxfce4ui # widgets

    xfce.mousepad
    xfce.xfce4-appfinder
    xfce.xfce4-notifyd
    xfce.xfce4-screenshooter
    xfce.xfce4-session
    xfce.xfce4-settings
    xfce.xfce4-taskmanager

    # tray plugins
    xfce.xfce4-power-manager
    xfce.xfce4-pulseaudio-plugin

    # window manager
    xfce.xfwm4
    xfce.xfwm4-themes

    # the rest of the desktop environment
    xfce.xfce4-panel
    xfce.xfdesktop
  ];
}

{pkgs, lib, config, ...}: {
  imports = [
    ./xfconf
    ./autorandr.nix
    ./picom.nix
  ];

  config = lib.mkIf config.modules.desktops.xorg.enable {
    modules.picom.enable = false;

    home.packages = with pkgs; [
      # xfce4-session binary is owned by home-manager
      xfce4-session

      # xfconf relies on system dbus, so it's enabled in
      # hosts/mnd/desktops/dbus.nix

      glib # for gsettings
      gtk3.out # gtk-update-icon-cache

      polkit_gnome

      desktop-file-utils
      shared-mime-info
      xdg-user-dirs # Needed by Xfce's xinitrc script

      xfce4-exo # default applications
      garcon # menu support
      libxfce4ui # widgets

      xfce4-appfinder
      xfce4-notifyd
      xfce4-screenshooter
      xfce4-session
      xfce4-settings
      xfce4-taskmanager

      # tray plugins
      xfce4-power-manager
      xfce4-pulseaudio-plugin

      # window manager
      xfwm4
      xfwm4-themes

      # the rest of the desktop environment
      xfce4-panel
      xfdesktop
    ];
  };
}

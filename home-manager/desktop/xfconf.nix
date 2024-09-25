{ ... }:

# This doesn't need to be a comprehensive set of xfconf settings, since many are automatically
# generated or easier to just set in the GUI. It's just the settings important to reproducing
# the system.

{
  xfconf.settings = {
    xsettings = {
      "Net/IconThemeName" = "buuf-icon-theme";
      "Xft/DPI" = 120;
      "Gtk/FontName" = "Sans 11";
      "Gtk/MonospaceFontName" = "Monospace 11";
      "Gtk/CursorThemeName" = "Adwaita";
      "Gdk/WindowScalingFactor" = 1;
    };
    xfce4-desktop = {
      "desktop-icons/icon-size" = 64;
      "desktop-icons/file-icons/show-device-removable" = false;
    };
    # TODO: add the rest of the xfconf settings
    # especially xfwm stuff, like the window decoration theme
    # maybe it would be good to have keyboard shortcuts too
  };
}

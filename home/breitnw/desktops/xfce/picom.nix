{...}:
# for my compositor, I use picom, which is a fork of compton.
# I don't know if it can solve the vsync issues (some posts
# have said it can), but it looks pretty regardless.
# TODO does this mean I need to somehow turn off the default
# xfwm4 compositor in my config?
{
  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    fadeDelta = 3;
    backend = "glx";

    # don't show a shadow for the dock or windows with weird frames
    shadowExclude = [
      "class_g = 'Xfce4-panel' && window_type = 'dock'"
      "class_g = 'Xfce4-screenshooter'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    # shadows are drawn wrong for menus, so disable them
    wintypes = {
      popup_menu.shadow = false;
      dropdown_menu.shadow = false;
      utility.shadow = false;
      notification.shadow = false;
    };
    settings = {
      blur = {
        method = "gaussian";
        size = 5;
        deviation = 3.0;
      };
      blur-background-exclude = [
        "class_g = 'Xfce4-notifyd'"
        "class_g = 'Xfce4-screenshooter'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      use-damage = true;
      # glx-no-stencil = true;
      # force-win-blend = true;
    };
  };
}

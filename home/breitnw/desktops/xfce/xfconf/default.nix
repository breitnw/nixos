{
  pkgs,
  inputs,
  ...
} @ args: {
  imports = [
    ./options.nix # my XFCE options module
  ];
  config = {
    modules.de.xfconf = {
      windowManagerTheme = "Waza";

      settings = {
        # import other modules for complex settings
        xfce4-panel = import ./panel.nix args;
        xfce4-keyboard-shortcuts = import ./shortcuts.nix args;
        # basic icon/cursor theme and font settings. most of this stuff is
        # offloaded to the theme section of the config
        xsettings = {Xft.DPI = 80;};
        # desktop appearance
        xfce4-desktop = {
          desktop-icons = {
            icon-size = 48;
            file-icons.show-removable = false;
            file-icons.show-filesystem = true;
          };
        };
        # display support. I use autorandr, so profiles should not be enabled
        # when displays are connected/disconnected.
        displays = {
          AutoEnableProfiles = 0;
          Notify = 0;
        };
        # window manager. I use xfwm4 (the default) since I like the theme options
        xfwm4.general = {
          # configure the style of the titlebar and decorations
          shadow_opacity = 40;
          button_layout = "O|HMC";
          title_alignment = "left";
          # hold the super key to move windows
          easy_click = "Super";
          # when moving and resizing the window, don't show its contents
          box_move = true;
          box_resize = true;
          # disable mouse wheel interactions for rolling up windows and switching
          # workspaces
          mousewheel_rollup = false;
          scroll_workspaces = false;
          # use window snapping instead of edge resistance
          snap_resist = false;
          tile_on_move = true;
          wrap_windows = false;
          # windows should snap to the screen border and to other windows
          snap_to_border = true;
          snap_to_windows = true;
          snap_width = 30;
          # don't show border or titlebar when maximized
          borderless_maximize = true;
          titleless_maximize = true;
        };
        # mice and trackpads
        pointers = {
          Apple_Internal_Keyboard__Trackpad.Properties.libinput_Tapping_Enabled =
            0;
          MacBookPro171_Touch_Bar.Properties.Device_Enabled = 0;
        };
        # power manager
        xfce4-power-manager.xfce4-power-manager = {
          # when the power button is pressed, ask what to do
          power-button-action = 3;
        };
      };
    };
  };
}

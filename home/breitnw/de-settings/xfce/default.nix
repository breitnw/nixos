{ pkgs, ... } @ args:

{
  imports = [
    ./options.nix # my XFCE options module
    ./panel.nix
  ];
  config = {
    modules.de.xfce = {
      defaultFont = {
        family = "Cozette";
        weight = "Medium";
        size = 13;
        package = pkgs.cozette;
      };
      titleBarFont = {
        family = "creep";
        weight = "Bold";
        size = 12;
        package = pkgs.creep;
      };
      iconTheme = "buuf-icon-theme";
      cursorTheme = "RunescapeCursors";
      windowManagerTheme = "Blackwall";
      overrideDesktopTextColor = true;

      settings = {
        # basic icon/cursor theme and font settings. most of this stuff is offloaded to the
        # theme section of the config
        xsettings = {
          Xft.DPI = 80;
        };
        # desktop appearance
        xfce4-desktop = {
          desktop-icons = {
            icon-size = 60;
            file-icons.show-removable = false;
            file-icons.show-filesystem = true;
          };
        };
        # panel settings are defined in panel.nix
        xfce4-panel = import ./panel.nix args;
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
        # xfce4-keyboard-shortcuts = {
        #   "Commands"
        # };
      };
    };
  };
}
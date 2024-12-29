{ lib, config, pkgs, inputs, ... }:

# This doesn't need to be a comprehensive set of xfconf settings, since many are automatically
# generated or easier to just set in the GUI. It's just the settings important to reproducing
# the system.

let
  cfg = config.modules.desktops.xfce;
  font = lib.types.submodule {
    options = {
      family = lib.mkOption { type = lib.types.str; };
      weight = lib.mkOption { type = lib.types.str; };
      size = lib.mkOption { type = lib.types.int; };
      package = lib.mkOption { type = lib.types.package; };
    };
  };
  describeFont = font: "${font.family} ${font.weight} ${toString font.size}";

in {
  options = {
    modules.desktops.xfce = {
      defaultFont = lib.mkOption {
        default = {
          family = "Cozette";
          weight = "Medium";
          size = 13;
          package = pkgs.cozette;
        };
        type = font;
      };
      titleBarFont = lib.mkOption {
        default = {
          family = "creep";
          weight = "Bold";
          size = 12;
          package = pkgs.creep;
        };
        type = font;
      };
      iconTheme = lib.mkOption {
        default = "buuf-icon-theme";
        type = lib.types.str;
      };
      cursorTheme = lib.mkOption {
        default = "RunescapeCursors";
        type = lib.types.str;
      };
      windowManagerTheme = lib.mkOption {
        default = "Blackwall";
        description = "The xfwm4 theme to use";
        type = lib.types.str;
      };
      overrideDesktopTextColor = lib.mkOption {
        default = true;
        description = ''
          Whether to override the default desktop text color configured in the GTK theme with
          the foreground color (base05) from nix-colors
        '';
      };
    };
  };

  config = {
    # enabling fontconfig should regenerate cache when new font packages are added
    fonts.fontconfig.enable = true;
    home.packages = [ cfg.defaultFont.package cfg.titleBarFont.package ];

    xfconf.settings = {
      # basic icon/cursor theme and font settings. most of this stuff is offloaded to the
      # theme section of the config
      xsettings = {
        "Net/IconThemeName" = cfg.iconTheme; # TODO: fetch from github?
        "Gtk/CursorThemeName" = cfg.cursorTheme;
        "Gtk/FontName" = describeFont cfg.defaultFont;
        "Gtk/MonospaceFontName" = describeFont cfg.defaultFont;
        "Xft/DPI" = 80;
        "Gdk/WindowScalingFactor" = 1;
      };
      # desktop appearance
      xfce4-desktop = {
        "desktop-icons/icon-size" = 48;
        # don't show fixed (built in) devices, since running Asahi makes a lot of them
        "desktop-icons/file-icons/show-device-fixed" = false;
        # custom text color to make icons more visible
        "desktop-icons/use-custom-label-text-color" = cfg.overrideDesktopTextColor;
        "desktop-icons/label-text-color" = let
            hex = config.colorscheme.palette.base05;
            rgb = inputs.nix-colors.lib.conversions.hexToRGB hex;
            rgba = rgb ++ [ 255 ];
            rgba_scaled = map (val: val / 255.0) rgba;
          in rgba_scaled;
      };
      # window manager. I use xfwm4 (the default) since I like the theme options
      xfwm4 = {
        "general/borderless_maximize" = true;
        "general/box_move" = true;
        "general/box_resize" = true;
        "general/button_layout" = "O|HMC";
        "general/easy_click" = "Super";
        "general/shadow_opacity" = 40;
        "general/theme" = cfg.windowManagerTheme;
        "general/tile_on_move" = true;
        "general/title_font" = describeFont cfg.titleBarFont;
        "general/title_alignment" = "left";
        "general/snap_resist" = true;
        "general/snap_to_border" = true;
        "general/snap_to_windows" = true;
        "general/snap_width" = 30;
      };
      xfce4-panel = {
        # TODO configure color based on theme light or dark
      };
      # TODO configure keyboard shortcuts
    };
  };
}

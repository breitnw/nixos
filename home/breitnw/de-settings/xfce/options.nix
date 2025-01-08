{ lib, config, pkgs, inputs, ... }:

# A bridge between my configuration and the xfconf home-manager module

let
  cfg = config.modules.de.xfce;
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
    modules.de.xfce = {
      defaultFont = lib.mkOption { type = font; };
      titleBarFont = lib.mkOption { type = font; };
      iconTheme = lib.mkOption { type = lib.types.str; };
      cursorTheme = lib.mkOption { type = lib.types.str; };
      windowManagerTheme = lib.mkOption {
        description = "The xfwm4 theme to use";
        type = lib.types.str;
      };
      overrideDesktopTextColor = lib.mkOption {
        description = ''
          Whether to override the default desktop text color configured in the GTK theme with
          the foreground color (base05) from nix-colors
        '';
      };
      settings = lib.mkOption { };
    };
  };

  config = {
    # enabling fontconfig should regenerate cache when new font packages are added
    fonts.fontconfig.enable = true;
    home.packages = [ cfg.defaultFont.package cfg.titleBarFont.package ];

    # some settings are configured by other options (not directly configurable), so
    # configure them here instead of default.nix
    # modules.de.xfce.settings = {
    # };

    xfconf.enable = true;
    xfconf.settings = let
      generatedSettings = {
        # set the themes and fonts
        # ... for xfce
        xsettings = {
          Net.IconThemeName = cfg.iconTheme;
          Gtk = {
            CursorThemeName = cfg.cursorTheme;
            FontName = describeFont cfg.defaultFont;
            MonospaceFontName = describeFont cfg.defaultFont;
          };
        };
        # ... and for xfwm4
        xfwm4.general = {
          theme = cfg.windowManagerTheme;
          title_font = describeFont cfg.titleBarFont;
        };
        # configure desktop icon text color
        # FIXME not sure if this works with XFCE 4.19
        xfce4-desktop.desktop-icons = {
          use-custom-label-text-color = cfg.overrideDesktopTextColor;
          # TODO does this still work?
          label-text-color = let
            hex = config.colorscheme.palette.base05;
            rgb = inputs.nix-colors.lib.conversions.hexToRGB hex;
            rgba = rgb ++ [ 255 ];
            rgba_scaled = map (val: val / 255.0) rgba;
          in rgba_scaled;
        };
      };
      # For some reason, the xfconf home-manager module represents setting names by
      # concatenating categories with a "/", instead of just taking a recursive
      # attribute set. This will generate the settings from a recursive attribute set
      # (easier to write) in the way home-manager wants
      flattenAttrs' = currentPath: attrs:
        lib.concatMapAttrs (name: val:
          if (builtins.isAttrs val) then
            flattenAttrs' (currentPath ++ [ name ]) val
          else {
            ${builtins.concatStringsSep "/" (currentPath ++ [ name ])} = val;
          }) attrs;
      flattenAttrs = flattenAttrs' [ ];
      # deeply merge the configured attributes with the generated ones and flatten
      mergedAttrs = lib.recursiveUpdate cfg.settings generatedSettings;
      flattenedAttrs =
        lib.attrsets.mapAttrs (name: value: flattenAttrs value) mergedAttrs;
    in flattenedAttrs;
  };
}

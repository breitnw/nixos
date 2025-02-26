{ lib, config, pkgs, inputs, ... }:

# A bridge between my configuration and the xfconf home-manager module

let
  cfg = config.modules.de.xfconf;
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
    modules.de.xfconf = {
      defaultFont = lib.mkOption { type = font; };
      titleBarFont = lib.mkOption { type = font; };
      iconTheme = lib.mkOption { type = lib.types.str; };
      cursorTheme = lib.mkOption { type = lib.types.str; };
      windowManagerTheme = lib.mkOption {
        description = "The xfwm4 theme to use";
        type = lib.types.str;
      };
      customDesktopTextColor = lib.mkOption {
        description = ''
          The default text color to use for the desktop.
          - "theme": base05 of the nix-colors palette is used
          - "original": the default xfdesktop text color is used
          - listOf float: use the specified RGBA value
        '';
        type = lib.types.oneOf [
          (lib.types.enum [ "original" "theme" ])
          (lib.types.listOf lib.types.float)
        ];
        default = "theme";
      };
      customPanelBackgroundColor = lib.mkOption {
        description = ''
          the custom (RGBA) background color to use for xfce-panel
          - null: use the panel background for the base16 theme
          - listOf float: use the specified RGBA value'';
        type = lib.types.nullOr (lib.types.listOf lib.types.float);
        default = null;
      };
      settings = lib.mkOption {
        default = { };
        type = lib.types.attrsOf lib.types.attrs;
      };
    };
  };

  config = {
    # enabling fontconfig should regenerate cache when new font packages are added
    fonts.fontconfig.enable = true;
    home.packages = [ cfg.defaultFont.package cfg.titleBarFont.package ];

    xfconf.enable = true;
    xfconf.settings = let
      # some settings are configured by other options (not directly configurable), so
      # configure them here instead of default.nix
      generatedSettings = {
        # set the themes and fonts
        # ... for xfce
        xsettings = {
          Net = {
            IconThemeName = cfg.iconTheme;
            ThemeName = config.modules.themes.themeName;
          };
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
        xfce4-desktop.desktop-icons = {
          use-custom-label-text-color =
            (cfg.customDesktopTextColor != "original");
          label-text-color =
            if (builtins.isString cfg.customDesktopTextColor) then
              let
                hex = config.colorscheme.palette.base05;
                rgb = inputs.nix-colors.lib.conversions.hexToRGB hex;
                rgba = rgb ++ [ 255 ];
                rgba_scaled = map (val: val / 255.0) rgba;
              in rgba_scaled
            else
              cfg.customDesktopTextColor;
        };
      };

      # The xfconf home-manager module represents setting names by concatenating
      # categories with a "/", instead of just taking a recursive
      # attribute set. This will generate the settings from a recursive attribute set
      # (easier to write) in the way home-manager wants
      flattenAttrs' = currentPath: attrs:
        lib.concatMapAttrs (name: val:
          # If val is an atterset, recursively flatten it
          if (builtins.isAttrs val) then
            flattenAttrs' (currentPath ++ [ name ]) val
            # if the attribute is named VALUE, it represents the value for the
            # current path (which may have sub-paths)
          else if (name == "VALUE") then {
            ${builtins.concatStringsSep "/" currentPath} = val;
          }
          # Otherwise, the value is the used for the path ending in the
          # attribute name
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

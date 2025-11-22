{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
# A bridge between my configuration and the xfconf home-manager module
let
  cfg = config.modules.de.xfconf;
in {
  options = {
    modules.de.xfconf = {
      windowManagerTheme = lib.mkOption {
        description = "The xfwm4 theme to use";
        type = lib.types.str;
      };
      desktopTextColor = lib.mkOption {
        description = ''
          The default text color to use for the desktop.
          - "theme": base05 of the nix-colors palette is used
          - "original": the default xfdesktop text color is used
          - listOf float: use the specified RGBA value
        '';
        type = lib.types.oneOf [
          (lib.types.enum ["original" "theme"])
          (lib.types.listOf lib.types.float)
        ];
        default = "original";
      };
      panelBackgroundColor = lib.mkOption {
        description = ''
          the custom (RGBA) background color to use for xfce-panel
          - null: use the default panel background
          - listOf float: use the specified RGBA value'';
        type = lib.types.nullOr (lib.types.listOf lib.types.float);
        default = null;
      };
      panelOpacity = lib.mkOption {
        description = "the opacity of the panel, as a percentage";
        type = lib.types.int;
        default = 100;
      };
      settings = lib.mkOption {
        default = {};
        type = lib.types.attrsOf lib.types.attrs;
      };
    };
  };

  config = {
    xfconf.enable = config.modules.desktops.xorg.enable;
    xfconf.settings = let
      describeFont = config.utils.fonts.describeFont;
      # some settings are configured by other options (not directly configurable), so
      # configure them here instead of default.nix
      generatedSettings = {
        # set the themes and fonts for xfwm4
        xfwm4.general = {
          theme = cfg.windowManagerTheme;
          title_font = describeFont config.utils.fonts.active.secondary;
        };
        # configure desktop icon text color
        xfce4-desktop.desktop-icons = {
          use-custom-label-text-color =
            cfg.desktopTextColor != "original";
          label-text-color =
            if (builtins.isString cfg.desktopTextColor)
            then let
              hex = config.colorscheme.palette.base05;
              rgb = inputs.nix-colors.lib.conversions.hexToRGB hex;
              rgba = rgb ++ [255];
              rgba_scaled = map (val: val / 255.0) rgba;
            in
              rgba_scaled
            else cfg.desktopTextColor;
        };
      };

      # The xfconf home-manager module represents setting names by concatenating
      # categories with a "/", instead of just taking a recursive
      # attribute set. This will generate the settings from a recursive attribute set
      # (easier to write) in the way home-manager wants
      flattenAttrs' = currentPath: attrs:
        lib.concatMapAttrs (name: val:
          # If val is an atterset, recursively flatten it
            if (builtins.isAttrs val)
            then flattenAttrs' (currentPath ++ [name]) val
            # if the attribute is named VALUE, it represents the value for the
            # current path (which may have sub-paths)
            else if (name == "VALUE")
            then {
              ${builtins.concatStringsSep "/" currentPath} = val;
            }
            # Otherwise, the value is the used for the path ending in the
            # attribute name
            else {
              ${builtins.concatStringsSep "/" (currentPath ++ [name])} = val;
            })
        attrs;
      flattenAttrs = flattenAttrs' [];
      # deeply merge the configured attributes with the generated ones and flatten
      mergedAttrs = lib.recursiveUpdate cfg.settings generatedSettings;
      flattenedAttrs =
        lib.attrsets.mapAttrs (name: value: flattenAttrs value) mergedAttrs;
    in
      flattenedAttrs;
  };
}

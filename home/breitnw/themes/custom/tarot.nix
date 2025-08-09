{
  config,
  inputs,
  ...
}: {
  modules.de.xfconf.customPanelBackgroundColor = [0.0 0.0 0.0 1.0];
  modules.de.xfconf.customDesktopTextColor = let
    hex = config.colorscheme.palette.base07;
    rgb = inputs.nix-colors.lib.conversions.hexToRGB hex;
    rgba = rgb ++ [255];
    rgba_scaled = map (val: val / 255.0) rgba;
  in
    rgba_scaled;
  # modules.de.xfconf.customDesktopTextColor = "original";
}

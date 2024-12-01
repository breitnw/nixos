{ lib, config, ... }:

let
  cfg = config.modules.kitty;
in

{
  options = {
    modules.kitty = {
      enable = lib.mkEnableOption
        "whether to enable the kitty configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        window_margin_width = 6;
        shell = "fish";
      };
      # theme is configured in desktop/themes
    };
  };
}

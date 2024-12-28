{ lib, config, ... }:

let
  cfg = config.modules.alacritty;
in

{
  options = {
    modules.alacritty = {
      enable = lib.mkEnableOption
        "whether to enable the alacritty configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        colors = with config.colorscheme.palette; {
          # adapted from https://github.com/aarowill/base16-alacritty/blob/master/templates/default.mustache
          draw_bold_text_with_bright_colors = false;
          cursor = {
            text = "0x${base00}";
            cursor = "0x${base0F}";
          };
          primary = {
            background = "0x${base00}";
            foreground = "0x${base05}";
          };
          normal = {
            black = "0x${base00}";
            red = "0x${base08}";
            green = "0x${base0B}";
            yellow = "0x${base0A}";
            blue = "0x${base0D}";
            magenta = "0x${base0E}";
            cyan = "0x${base0C}";
            white = "0x${base05}";
          };
        };
        window = {
          padding = {
            x = 6;
            y = 6;
          };
          dimensions = {
            columns = 60;
            lines = 20;
          };
        };
        font.normal = {
          family = "Cozette";
          style = "Medium";
        };
        cursor.style.shape = "Underline";
        shell = "fish";
      };
    };
  };
}

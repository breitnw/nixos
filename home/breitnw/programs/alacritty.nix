{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.alacritty;
  # base16-alacritty provides the mustache template for
  # the color scheme
  base16-alacritty = "${inputs.base16-alacritty}/templates/default-256.mustache";
in {
  options = {
    modules.alacritty = {
      enable =
        lib.mkEnableOption "whether to enable the alacritty configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      package = pkgs.unstable.alacritty-graphics;
      settings = {
        general.import = let
          themeFile = pkgs.writeTextFile {
            name = "base16.toml";
            text = config.utils.mustache.eval-base16 (builtins.readFile base16-alacritty);
          };
        in [themeFile];
        window = {
          padding = {
            x = 6;
            y = 6;
          };
          dimensions = {
            columns = 60;
            lines = 17;
          };
        };
        font = let
          monospace = config.utils.fonts.monospace;
        in {
          normal = {
            inherit (monospace) family;
            style = monospace.weight;
          };
          inherit (monospace) size;
          builtin_box_drawing = false;
        };
        cursor.style.shape = "Block";
        terminal.shell = {
          program = "zsh";
          args = [
            "-c"
            "fastfetch && exec zsh"
          ];
        };
      };
    };
  };
}

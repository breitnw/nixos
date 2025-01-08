{ pkgs, lib, config, ... }:

let
  cfg = config.modules.alacritty;
  # base16-alacritty provides the mustache template for
  # the color scheme
  base16-alacritty-repo = fetchGit {
    url = "https://github.com/aarowill/base16-alacritty.git";
    rev = "c95c200b3af739708455a03b5d185d3d2d263c6e";
  };
  base16-alacritty = "${base16-alacritty-repo}/templates/default-256.mustache";

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
      settings = {
        general.import = let
          themeFile = pkgs.writeTextFile {
            name = "base16.toml";
            text = config.utils.mustache.eval-base16 (builtins.readFile base16-alacritty);
          };
        in [ themeFile ];
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
        cursor.style.shape = "Block";
        terminal.shell = "fish";
      };
    };
  };
}

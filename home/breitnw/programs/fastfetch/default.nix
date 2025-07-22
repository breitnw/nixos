{
  lib,
  config,
  ...
}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = ./images/2.jpg;
        type = "sixel";
        height = 15;
        padding = {
          right = 1;
        };
      };

      display = {
        separator = " ★ ";
      };

      modules = let
        keyPadding = 8;
        pad = name:
          name
          + (lib.strings.replicate (keyPadding - builtins.stringLength name)
            " ");
        paddedModule = name: {
          type = name;
          key = pad name;
        };
        paddedModuleCustom = name: format: {
          type = "custom";
          key = pad name;
          inherit format;
        };
      in [
        {
          type = "title";
          format = "[ {user-name-colored}{at-symbol-colored}{host-name-colored} ]";
        }
        {
          type = "datetime";
          keyWidth = 1;
          format = "...on {8}, {6} {23}, {1}";
          outputColor = "yellow";
        }
        "break"
        # system status
        ((paddedModule "disk") // {keyColor = "magenta";})
        ((paddedModule "memory") // {keyColor = "magenta";})
        ((paddedModule "battery") // {keyColor = "magenta";})
        "break"
        # system info
        (paddedModule "host")
        # (paddedModule "display")
        (paddedModule "os")
        (paddedModule "kernel")
        (paddedModule "de")
        (paddedModule "shell")
        (paddedModule "terminal")
        # (paddedModule "icons")
        (paddedModuleCustom "theme" (config.modules.themes.themeName + " (base16)"))
        (paddedModule "font")
        # "break"
        # {
        #   type = "colors";
        #   symbol = "block";
        #   paddingLeft = 4;
        #   block.range = [8 7 6 5 4 3 2 1];
        # }
      ];
    };
  };
}

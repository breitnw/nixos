{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    modules.fastfetch = {
      image = lib.mkOption {
        default = ./images/4.jpg;
        type = lib.types.path;
      };
    };
  };
  config = {
    programs.fastfetch = let
      name = "crop.jpg";
      # this works but it kinda sucks
      crop = aspect: image: "${pkgs.runCommand name {} ''
          mkdir $out
        ${pkgs.imagemagick}/bin/magick ${image} -gravity center -crop ${aspect} $out/${name}
      ''}/crop.jpg";
    in {
      enable = true;
      settings = {
        logo = {
          source = lib.mkDefault (crop "9:16" config.modules.fastfetch.image); # so that we can customize per-theme
          type = "sixel";
          height = 14;
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
          # (paddedModule "kernel")
          # print the desktop environment if we're on xorg, and the window manager
          # if we're on wayland
          (
            if config.modules.desktops.primary_display_server == "xorg"
            then (paddedModule "de")
            else (paddedModule "wm")
          )
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
  };
}

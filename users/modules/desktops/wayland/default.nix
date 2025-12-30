{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  config = let
    base00-darker = with inputs.nix-rice.lib.nix-rice;
      color.toRgbShortHex (color.darken 6
        (color.hexToRgba "#${config.colorscheme.palette.base00}"));
    base00-lighter = with inputs.nix-rice.lib.nix-rice;
      color.toRgbShortHex (color.brighten 20
        (color.hexToRgba "#${config.colorscheme.palette.base00}"));
    base00-lightest = with inputs.nix-rice.lib.nix-rice;
      color.toRgbShortHex (color.brighten 35
        (color.hexToRgba "#${config.colorscheme.palette.base00}"));
  in
    lib.mkIf config.modules.desktops.wayland.enable {
      home.packages = with pkgs; [
        swaybg # wallpaper
        fuzzel # application picker
        hyprpicker # color picker
      ];

      # low battery alerts
      # services.batsignal.enable = true;
      # services.batsignal.extraArgs = [
      #   "-p" # send notifications when plugged/unplugged
      #   "-e" # notifications expire
      #   "-m"
      #   "15" # 15-second interval
      #   "-I"
      #   "${inputs.buuf-icon-theme}/128x128/battery-green-full.png" # this hack is hideous
      # ];

      # fuzzel config
      xdg.configFile."fuzzel/fuzzel.ini".text = lib.generators.toINI {} {
        main = {
          icon-theme = config.gtk.iconTheme.name;
          hide-prompt = true;
          horizontal-pad = 30;
          vertical-pad = 20;
        };
        colors = with config.colorScheme.palette; {
          background = "${base00}FF";
          text = "${base05}FF";
          prompt = "${base03}FF";
          placeholder = "${base03}FF";
          input = "${base03}FF";
          match = "${base0D}FF";
          selection = "${base01}FF";
          selection-text = "${base05}FF";
          selection-match = "${base0D}FF";
          counter = "${base05}FF";
          border = "${base00-lighter}FF";
        };
        # TODO can border/shadow be configured in niri instead?
        border = {
          width = 1;
          radius = 16;
          selection-radius = 4;
        };
      };

      # waybar config
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile."waybar/style.css".source = let
        style-header = pkgs.writeTextFile {
          name = "style-header.css";
          text =
            config.utils.mustache.eval-base16-with-palette
            (config.colorScheme.palette
              // {inherit base00-darker base00-lighter base00-lightest;})
            ./waybar/style-header.css.mustache;
        };
        style-body = ./waybar/style.css;
      in
        pkgs.concatTextFile {
          name = "style.css";
          files = [style-header style-body];
        };

      xdg.configFile."waybar/config.jsonc".source = pkgs.substitute {
        src = ./waybar/config.jsonc;
        substitutions = [
          "--replace"
          "@notify-send-bin@"
          "${pkgs.libnotify}/bin/notify-send"
        ];
      };
    };

  imports = [
    ./niri
    ./sway
  ];
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # DISABLED
    # ./waybar.nix
  ];
  options = {
    modules.sway = {
      enable = lib.mkEnableOption "whether to enable the Sway window manager";
    };
  };
  config = lib.mkIf config.modules.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        gaps = {
          inner = 10;
        };
        modifier = "Mod4"; # super
        terminal = "alacritty";
        output = {
          "eDP-1" = {
            mode = "1280x800@60Hz";
          };
        };
        focus.followMouse = false;
        input = {
          "*" = {
            xkb_layout = "us";
            xkb_variant = "colemak";
            xkb_options = "caps:escape";
          };
        };

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
          lib.mkOptionDefault {
            "${modifier}+q" = "exec qutebrowser";
            "${modifier}+c" = "exec emacsclient --create-frame";
          };
      };
      extraConfig = ''
        output "*" bg ${./wallpaper.jpg} fill

        # Volume
        bindsym XF86AudioRaiseVolume exec '${pkgs.pamixer}/bin/pamixer -i 10'
        bindsym XF86AudioLowerVolume exec '${pkgs.pamixer}/bin/pamixer -d 10'
        bindsym XF86AudioMute exec '${pkgs.pamixer}/bin/pamixer -t'
      '';
    };
    home.packages = [
      pkgs.pulseaudio-ctl
    ];
    services.mako.enable = true;
  };
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    modules.sway = {
      enable = lib.mkEnableOption "whether to enable the Sway window manager";
    };
  };
  config = with inputs.nix-rice.lib.nix-rice; let
    colors = with inputs.nix-rice.lib.nix-rice; rec {
      accent = config.colorscheme.palette.base0D;
      accentMid =
        color.toRgbHex (color.darken 40
          (color.hexToRgba "#${accent}"));
      accentDark =
        color.toRgbHex (color.darken 80
          (color.hexToRgba "#${accent}"));
      accentLight =
        color.toRgbHex (color.brighten 20
          (color.hexToRgba "#${accent}"));
    };
  in
    lib.mkIf config.modules.sway.enable {
      wayland.windowManager.sway = {
        enable = true;
        config = {
          gaps = {
            inner = 10;
            outer = 5;
          };
          window.border = 2;
          defaultWorkspace = "workspace number 1";
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
          menu = "${pkgs.wofi}/bin/wofi --show drun";

          left = "h";
          down = "n";
          up = "e";
          right = "i";

          keybindings = let
            cfg = config.wayland.windowManager.sway.config;
            modifier = cfg.modifier;
          in {
            "${modifier}+q" = "exec qutebrowser";
            "${modifier}+o" = "exec emacsclient --create-frame";
            "${modifier}+t" = "exec ${cfg.terminal}";
            "${modifier}+m" = "exec alacritty -o 'window.dimensions.columns = 70' -o 'window.dimensions.lines=22' -e rmpc";
            "${modifier}+c" = "exec alacritty -o 'cursor.style=\"Beam\"' -e ikhal";
            "${modifier}+Space" = "exec ${cfg.menu}";

            "${modifier}+w" = "kill";

            "${modifier}+${cfg.left}" = "focus left";
            "${modifier}+${cfg.down}" = "focus down";
            "${modifier}+${cfg.up}" = "focus up";
            "${modifier}+${cfg.right}" = "focus right";

            "${modifier}+Shift+${cfg.left}" = "move left";
            "${modifier}+Shift+${cfg.down}" = "move down";
            "${modifier}+Shift+${cfg.up}" = "move up";
            "${modifier}+Shift+${cfg.right}" = "move right";

            "${modifier}+s" = "splith";
            "${modifier}+v" = "splitv";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+a" = "focus parent";

            "${modifier}+k" = "layout stacking";
            "${modifier}+b" = "layout tabbed";
            "${modifier}+p" = "layout toggle split";

            "${modifier}+Return" = "floating toggle";
            "${modifier}+Shift+Return" = "focus mode_toggle";

            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";

            "${modifier}+Shift+1" = "move container to workspace number 2";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";

            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+minus" = "scratchpad show";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+x" = "exec ${pkgs.wlogout}/bin/wlogout";

            "${modifier}+r" = "mode resize";
          };

          colors = {
            # TODO set gray colors with config too!
            # TODO also could modify this based on light or dark theme
            focused = {
              border = colors.accentDark;
              childBorder = "#333333";
              background = colors.accentMid;
              indicator = colors.accent;
              text = "#ffffff";
            };
            focusedInactive = {
              background = "#5f676a";
              childBorder = "#333333";
              border = "#333333";
              indicator = "#484e50";
              text = "#ffffff";
            };
          };

          bars = [
            {
              mode = "dock";
              hiddenState = "hide";
              position = "bottom";
              workspaceButtons = true;
              workspaceNumbers = true;
              statusCommand = "${pkgs.i3status}/bin/i3status";
              fonts = {
                names = ["monospace"];
                size = 8.0;
              };
              trayOutput = "primary";
              colors = {
                background = "#000000";
                statusline = "#ffffff";
                separator = "#666666";
                focusedWorkspace = {
                  border = colors.accentDark;
                  background = colors.accent;
                  text = "#ffffff";
                };
              };
            }
          ];
        };

        # TODO verify clamshell mode works
        extraConfig = ''
          output "*" bg ${./wallpaper.jpg} fill

          # Volume
          bindsym XF86AudioRaiseVolume exec '${pkgs.pamixer}/bin/pamixer -i 10'
          bindsym XF86AudioLowerVolume exec '${pkgs.pamixer}/bin/pamixer -d 10'
          bindsym XF86AudioMute exec '${pkgs.pamixer}/bin/pamixer -t'

          # Brightness
          bindsym XF86MonBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-
          bindsym XF86MonBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%+

          # Clamshell mode
          set $laptop eDP-1
          bindswitch --reload --locked lid:on output $laptop disable
          bindswitch --reload --locked lid:off output $laptop enable
        '';
      };

      programs.wofi = {
        enable = true;
        style = ''
          * {
            font-family: CozetteVector;
            font-size: 13px;
          }
        '';
      };

      # FIXME i don't think mako actually does anything :(
      services.mako.enable = true;
    };
}

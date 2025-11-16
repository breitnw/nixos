{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  # helper definitions used for styling across multiple apps
  base00-darker = with inputs.nix-rice.lib.nix-rice;
    color.toRgbShortHex (color.darken 6
      (color.hexToRgba "#${config.colorscheme.palette.base00}"));
  border = {
    width = 3;
    radius = 2.0;
  };
in {
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit
  home.packages = with pkgs; [
    swaybg # wallpaper
    waybar
    fuzzel
  ];

  # fuzzel config
  xdg.configFile."fuzzel/fuzzel.ini".text = lib.generators.toINI {} {
    main = {
      icon-theme = config.gtk.iconTheme.name;
    };
    colors = with config.colorScheme.palette; {
      background = "${base00}FF";
      text = "${base05}FF";
      prompt = "${base07}FF";
      placeholder = "${base03}FF";
      input = "${base07}FF";
      match = "${base0D}FF";
      selection = "${base01}FF";
      selection-text = "${base05}FF";
      selection-match = "${base0D}FF";
      counter = "${base05}FF";
      border = "${base00-darker}FF";
    };
    inherit border;
  };

  # waybar config
  xdg.configFile."waybar/style.css".source = let
    style-header = pkgs.writeTextFile {
      name = "style-header.css";
      text =
        config.utils.mustache.eval-base16-with-palette
        (config.colorScheme.palette // {inherit base00-darker;})
        ./waybar/style-header.css.mustache;
    };
    style-body = ./waybar/style.css;
  in
    pkgs.concatTextFile {
      name = "style.css";
      files = [style-header style-body];
    };
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;

  # niri config
  # see https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettingslayoutborder
  programs.niri = {
    package = pkgs.niri;
    settings = {
      input.touchpad = {
        natural-scroll = false;
        tap = false;
      };
      outputs."eDP-1" = {
        # mode = "2560x1600@60";
        scale = 1.5;
        position.x = 0;
        position.y = 0;
      };
      cursor = {
        theme = "Adwaita";
        size = 20;
      };
      layout = {
        gaps = 16;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
        ];
        default-column-width = {proportion = 0.5;};
        focus-ring = {
          enable = false;
        };
        border = {
          enable = true;
          width = border.width;
          active.color = config.colorscheme.palette.base00;
          inactive.color = config.colorscheme.palette.base00;
          urgent.color = config.colorscheme.palette.base0D;
        };
        shadow = {
          enable = true;
          softness = 20;
          spread = 2;
          offset.x = 0;
          offset.y = 1;
          color = "#0006";
        };
        insert-hint = {
          enable = true;
          display = {color = config.colorscheme.palette.base0D;};
        };
      };
      spawn-at-startup = [
        {argv = ["${pkgs.waybar}/bin/waybar"];}
        {argv = ["${pkgs.swaybg}/bin/swaybg" "--image" "${./DSCN0700.jpg}"];}
        {argv = ["${pkgs.mako}/bin/mako"];}
      ];
      prefer-no-csd = true;

      window-rules = [
        # floating picture-in-picture for firefox
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        # round window corners
        {
          geometry-corner-radius = {
            bottom-left = border.radius;
            bottom-right = border.radius;
            top-left = border.radius;
            top-right = border.radius;
          };
          clip-to-geometry = true;
        }
      ];

      layer-rules = [
        {
          matches = [{namespace = "waybar$";}];
          shadow = {
            enable = true;
            softness = 10;
            spread = 4;
            offset.x = 0;
            offset.y = -4;
            color = "#000A";
          };
        }
      ];

      binds = with config.lib.niri.actions; {
        # App shortcuts
        "Mod+T" = {
          hotkey-overlay.title = "Open Alacritty";
          action = spawn "${config.programs.alacritty.package}/bin/alacritty";
        };
        "Mod+C" = {
          hotkey-overlay.title = "Open Calendar";
          action =
            spawn "${config.programs.alacritty.package}/bin/alacritty"
            "-o" "'cursor.style=\"Beam\"'" "-e" "ikhal";
        };
        "Mod+O" = {
          hotkey-overlay.title = "Open Emacs";
          action =
            spawn "${config.programs.emacs.package}/bin/emacsclient"
            "--create-frame";
        };
        "Mod+Q" = {
          hotkey-overlay.title = "Open Web Browser";
          action =
            spawn "${config.programs.firefox.package}/bin/firefox"
            "--create-frame";
        };
        "Mod+Space" = {
          hotkey-overlay.title = "Run Fuzzel";
          action = spawn "${pkgs.fuzzel}/bin/fuzzel";
        };

        # Volume keys
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
        };

        # Brightness keys
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action = spawn "brightnessctl" "class=backlight" "set" "+10%";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action = spawn "brightnessctl" "class=backlight" "set" "10%-";
        };

        # Navigation
        "Mod+Tab" = {
          repeat = false;
          action = toggle-overview;
        };
        "Mod+W" = {
          repeat = false;
          action = close-window;
        };

        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;
        # TODO use global keyboard conf for vim keybinds?
        "Mod+H".action = focus-column-left;
        "Mod+N".action = focus-window-down;
        "Mod+E".action = focus-window-up;
        "Mod+I".action = focus-column-right;

        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+H".action = focus-column-left;
        "Mod+Ctrl+N".action = focus-window-down;
        "Mod+Ctrl+E".action = focus-window-up;
        "Mod+Ctrl+I".action = focus-column-right;

        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Right".action = focus-monitor-right;

        "Mod+Ctrl+Shift+Left".action = move-column-to-monitor-left;
        "Mod+Ctrl+Shift+Down".action = move-column-to-monitor-down;
        "Mod+Ctrl+Shift+Up".action = move-column-to-monitor-up;
        "Mod+Ctrl+Shift+Right".action = move-column-to-monitor-right;

        "Mod+L".action = focus-workspace-down;
        "Mod+U".action = focus-workspace-up;
        "Mod+Ctrl+L".action = move-column-to-workspace-down;
        "Mod+Ctrl+U".action = move-column-to-workspace-up;

        "Mod+WheelScrollDown".action = focus-column-right;
        "Mod+WheelScrollUp".action = focus-column-left;
        "Mod+Ctrl+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+WheelScrollUp".action = move-column-left;

        # Center all fully visible columns on screen
        "Mod+Ctrl+C".action = center-visible-columns;

        # Consume-expel windows
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        # Window resizing
        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = switch-preset-window-height;

        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Ctrl+F".action = expand-column-to-available-width;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        # Floating windows
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

        # Tabbed columns
        "Mod+B".action = toggle-column-tabbed-display;

        # Screenshot
        # "Mod+S".action = screenshot;
        # "Mod+Alt+S".action = screenshot-window {write-to-disk = true;};

        # Exit wayland session
        "Mod+X".action = quit;
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.modules.sway.enable {
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
  programs.waybar = {
    enable = true;
    style = lib.fileContents ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 15;
        spacing = 10;
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = ["sway/workspaces" "mpd"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "memory" "battery" "network" "tray"];

        "sway/workspaces" = {
          format = "<span size='larger' style='text-align:center'>{icon}</span>";
          on-click = "activate";
          format-icons = {
            active = " ";
            default = " ";
          };
          icon-size = 10;
        };
        sort-by-number = true;
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };

        tray = {
          icon-size = 16;
          spacing = 16;
        };

        clock.format = "{:%d.%m.%Y | %H:%M}";
        memory = {
          interval = 30;
          format = "  {used:0.1f}G";
        };
        battery = {
          format = "{icon}  {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        network = {
          format = "";
          format-ethernet = "󰈀";
          format-wifi = "{icon}";
          format-disconnected = "󰤮";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
        };

        pulseaudio = {
          scroll-step = 5;
          max-volume = 100;
          format = "󰓃  {volume}%";
          format-bluetooth = "󰂰  {volume}%";
          on-click = "pavucontrol";
        };
      };
    };
  };
}

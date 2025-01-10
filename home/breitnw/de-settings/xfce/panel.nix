{ config, ... }:

let
  icon-size = 16;
  describeFont = font: "${font.family} ${font.weight} ${toString font.size}";
  cfg = config.modules.de.xfce;
in {
  panels = {
    VALUE = [ 1 ];
    dark-mode = config.colorScheme.variant == "dark";
    panel-1 = {
      inherit icon-size;
      length = 100;
      size = 24;
      # is this right?
      position = "p=8;x=640;y=786";
      position-locked = true;
      plugin-ids = [ 1 2 3 4 5 6 7 8 9 10 11 12 ];
    };
  };
  plugins =
    let
      sep = {
        VALUE = "separator";
        expand = false;
        style = 0;
      };
      sep-expand = {
        VALUE = "separator";
        expand = true;
        style = 0;
      };
    in {
    plugin-1 = {
      VALUE = "tasklist";
      grouping = 1;
    };
    plugin-2 = sep-expand;
    plugin-3 = "pager";
    plugin-4 = sep;
    plugin-5 = {
      VALUE = "systray";
      inherit icon-size;
      square-icons = true;
    };
    plugin-6 = {
      VALUE = "pulseaudio";
      enable-keyboard-shortcuts = true;
      show-notifications = true;
    };
    plugin-8 = "power-manager-plugin";
    plugin-7 = "notification-plugin";
    plugin-9 = sep;
    plugin-10 = {
      VALUE = "clock";
      digital-layout = 3;
      digital-time-font = describeFont cfg.defaultFont;
    };
    plugin-11 = sep;
    plugin-12 = "actions";
  };
}

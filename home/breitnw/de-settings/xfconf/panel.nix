{ config, ... }:

# TODO organize plugin indices automatically

let
  icon-size = 16;
  describeFont = font: "${font.family} ${font.weight} ${toString font.size}";
  cfg = config.modules.de.xfconf;
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
      plugin-ids = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 ];
    };
  };
  plugins = let
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
      include-all-workspaces = true;
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
    plugin-7 = "power-manager-plugin";
    plugin-8 = "notification-plugin";
    plugin-9 = sep;
    plugin-10 = {
      VALUE = "clock";
      digital-layout = 3;
      digital-time-format = "%I:%M %p";
      digital-time-font = describeFont cfg.defaultFont;
    };
    plugin-11 = sep;
    plugin-12 = "actions";
    plugin-13 = sep;
  };
}

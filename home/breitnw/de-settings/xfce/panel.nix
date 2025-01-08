{ config, ... }:

let icon-size = 16;

in {
  modules.de.xfce.settings.xfce4-panel = {
    panels = {
      dark-mode = config.colorScheme.variant == "dark";
      panel-1 = {
        inherit icon-size;
        length = 100;
        size = 24;
        # is this right?
        position = "p=8;x=640;y=786";
        position-locked = true;
      };
    };
    plugins = {
      plugin-6 = {
        VALUE = "systray";
        inherit icon-size;
      };
    };
  };
}

{ lib, config, ... }:

# Doesn't currently work, may be an Asahi issue

let
  cfg = config.modules.redshift;
in
{
  options = {
    modules.redshift = {
      enable = lib.mkEnableOption
        "whether to enable the kitty configuration";
    };
  };
  config = lib.mkIf cfg.enable {
    services.redshift = {
      enable = true;
      longitude = "-87.688568";
      latitude = "42.0463392";
      provider = "manual";
      tray = true; # tray applet
      temperature.day = 3000;
      temperature.night = 3000;
      settings = {
        redshift = {
          adjustment-method = "randr";
        };
        randr = {
          screen = 0;
        };
      };
    };
  };
}

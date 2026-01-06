{ config, lib, ... }:

{
  # if gamma ramping is available (not available on asahi), turn on redshift
  services.redshift = lib.mkIf config.platform.available-features.gamma-ramp {
    enable = true;
    provider = "geoclue2";
    tray = true;
    temperature.day = 6000;
    temperature.night = 4500;
  };
}

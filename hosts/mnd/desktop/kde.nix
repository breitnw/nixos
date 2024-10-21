{ pkgs, config, lib, ... }:

let
  cfg = config.desktops.kde;
in
{
  options = {
    desktops.kde = {
      enable = lib.mkEnableOption "enable XFCE desktop environment";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.displayManager.defaultSession = "plasma";
  };
}

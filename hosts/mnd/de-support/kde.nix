{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.desktops.kde;
  default = config.desktops.default == "kde";
in {
  options = {
    desktops.kde = {
      enable = lib.mkEnableOption "enable XFCE desktop environment";
    };
  };

  config = lib.mkIf cfg.enable {
    # services.displayManager.sddm.enable = true;
    # services.displayManager.defaultSession = lib.mkIf default "plasma";

    services.desktopManager.plasma6.enable = true;
    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      gwenview
      okular
      oxygen
      khelpcenter
      konsole
      plasma-browser-integration
      print-manager
      dolphin
      dolphin-plugins
      kwallet
    ];
  };
}

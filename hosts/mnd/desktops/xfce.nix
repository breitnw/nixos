# XFCE and all the fixins
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.desktops.xfce;
  default = config.desktops.default == "xfce";
in {
  options = {
    desktops.xfce = {
      enable = lib.mkEnableOption "enable XFCE desktop environment";
    };
  };

  config = lib.mkIf cfg.enable {
    # enable xserver
    services.xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      excludePackages = [pkgs.xterm];
    };
    # enable xfconf (required by home-manager)
    programs.xfconf.enable = true;
    # It doesn't appear XFCE has a bluetooth GUI, so blueman provides this
    services.blueman.enable = true;
    # XFCE-specific packages
    environment.systemPackages = with pkgs; [
      # a volume mixer
      pavucontrol
      # default application support (this doesn't work otherwise fsr)
      xfce.exo
    ];
  };
}

# XFCE and all the fixins
{ lib, pkgs, config, ... }:

let
  cfg = config.desktops.xfce;
  default = config.desktops.default == "xfce";
in {
  options = {
    desktops.xfce = {
      enable = lib.mkEnableOption "enable XFCE desktop environment";
    };
  };

  config = lib.mkIf cfg.enable {
    # use xfce 4.20!
    # nixpkgs.overlays = [ (final: prev: { xfce = final.unstable.xfce; }) ];
    # enable xserver
    services.xserver.enable = true;
    # enable xfconf (required by home-manager)
    programs.xfconf.enable = true;
    # enable XFCE and configure it as the default session
    services.xserver.desktopManager.xfce.enable = true;
    services.displayManager.defaultSession = lib.mkIf default "xfce";
    # It doesn't appear XFCE has a bluetooth GUI, so blueman provides this
    services.blueman.enable = true;
    # XFCE-specific packages
    environment.systemPackages = with pkgs; [
      # Since we don't use pulseaudio, we won't get this automatically...
      # but it will still work because pipewire is a "drop-in" replacement
      # for pulseaudio
      # xfce.xfce4-pulseaudio-plugin
      # a volume mixer
      pavucontrol
      # default application support (this doesn't work otherwise fsr)
      xfce.exo
    ];
  };
}

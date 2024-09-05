# Touchbar support service

{ pkgs, lib, config, ... }:

let
  cfg = config.services.tiny-dfr;
in {
  options = {
    services.tiny-dfr = {
      enable = lib.mkEnableOption "Enable tiny-dfr service";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.tiny-dfr;
        defaultText = pkgs.tiny-dfr;
        description = "Set version of tiny-dfr package to use";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ "tiny-dfr" ];
    # services.dbus.packages = [ "tiny-dfr" ];
    systemd.services.tiny-dfr = {
      description = "Touchbar daemon";

      # wanted-by = [ "multi-user.target" ];
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "plymouth-quit.service"
        "systemd-logind.service"
        "dev-tiny_dfr_display.device"
        "dev-tiny_dfr_backlight.device"
        "dev-tiny_dfr_display_backlight.device"
      ];

      bindsTo = [
        "dev-tiny_dfr_display.device"
        "dev-tiny_dfr_backlight.device"
        "dev-tiny_dfr_display_backlight.device"
      ];

      restartIfChanged = false;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tiny-dfr";
        DynamicUser = false; # run as sudo
      };
    };
  };
}

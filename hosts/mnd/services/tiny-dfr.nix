# Touchbar support service

{ pkgs, lib, config, ... }:

let cfg = config.services.tiny-dfr;
in {
  options = {
    services.tiny-dfr = {
      enable = lib.mkEnableOption "Enable tiny-dfr service";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.tiny-dfr;
        defaultText = "pkgs.tiny-dfr";
        description = "Set version of tiny-dfr package to use";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services."tiny-dfr" = {
      description = "Touchbar daemon";
      wantedBy = [ "multi-user.target" ];
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "plymouth-quit.service"
        "systemd-logind.service"
      ];

      restartIfChanged = false;

      serviceConfig = {
        # should automatically be interpolated, installing tiny-dfr
        ExecStart = "${cfg.package}/bin/tiny-dfr";
        DynamicUser = false; # run as sudo
      };
    };
    # https://github.com/AsahiLinux/tiny-dfr/blob/master/share/tiny-dfr/config.toml
    environment.etc."tiny-dfr/config.toml".text = ''
      MediaLayerDefault = true
    '';
  };
}

{
  lib,
  config,
  ...
}:
# FIXME currently, it seems that displaylink causes issues with suspending
# the system. See /etc/systemd/system/pre-sleep.service
# also: /nix/store/...-unit-script-pre-sleep-start/bin/pre-sleep-start
let
  cfg = config.modules.output.displaylink;
in {
  options = {
    modules.output.displaylink.enable =
      lib.mkEnableOption "whether to enable displaylink support";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) ["displaylink"];
    systemd.services.dlm.wantedBy = ["multi-user.target"];
    services.xserver.videoDrivers = ["displaylink"];
    # services.xserver.deviceSection = ''
    #   Option "AsyncFlipSecondaries" "true"
    # '';
  };
}

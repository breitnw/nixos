{ lib, config, ... }:

# FIXME currently, it seems that displaylink causes issues with suspending
# the system. See /etc/systemd/system/pre-sleep.service

let
  cfg = config.hardware.displaylink;
in {
  options = {
    hardware.displaylink.enable = lib.mkEnableOption "whether to enable displaylink support";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "displaylink"
      ];
    services.xserver = {
      videoDrivers = [ "displaylink" "modesetting" ];
    };
  };
}

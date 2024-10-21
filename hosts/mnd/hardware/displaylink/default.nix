{ lib, config, ... } @ args:

let
  cfg = config.hardware.displaylink;
in {
  options = {
    hardware.displaylink.enable = lib.mkEnableOption("whether to enable displaylink support");
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        displaylink = import ./dl-overlay args;
      })
    ];
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "displaylink"
      ];
    services.xserver = {
      videoDrivers = [ "displaylink" "modesetting" ];
    };
  };
}

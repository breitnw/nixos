{ pkgs, lib, config, ... }:

# enable platformio (emacs plugin and command line tools)

let
  cfg = config.modules.pio;
in {
  options = {
    modules.pio = {
      enable = lib.mkEnableOption "Whether to enable PlatformIO support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.platformio
    ];

    programs.emacs.extraPackages = epkgs: [
      epkgs.platformio-mode
    ];
  };
}

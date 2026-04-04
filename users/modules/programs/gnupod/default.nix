{ config, pkgs, inputs, lib, ... }:

let
  cfg = config.modules.gnupod;
in {
  options = {
    modules.gnupod = {
      enable =
        lib.mkEnableOption "whether to enable the gnupod program and configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.gnupod.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.file.".gnupodrc".source = ./gnupodrc;
  };
}

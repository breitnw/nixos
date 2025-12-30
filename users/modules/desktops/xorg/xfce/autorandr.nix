{config, lib, ...}:

let
  # displays are configured at the system-level
  # see systems/[system name].nix to configure
  cfg = config.sysinfo.display-management;
in lib.mkIf config.modules.desktops.xorg.enable {
  services.autorandr.enable = true;
  programs.autorandr = {
    enable = true;
    profiles = builtins.mapAttrs (prof-name: prof-value: {
      # fingerprint of each display used in this profile
      fingerprint = builtins.mapAttrs (disp-name: disp-value:
        cfg.displays.${disp-name}.fingerprint
      ) prof-value;

      # configuration of each display in this profile
      config = builtins.mapAttrs (disp-name: disp-value: let
        disp-info = cfg.displays.${disp-name};
        width = disp-info.pixel-size.width;
        height = disp-info.pixel-size.height;
      in {
        inherit (disp-value) primary position;
        mode = "${toString width}x${toString height}";
        filter = "nearest";
        transform = [
          [(1.0 / disp-info.scale.xorg) 0.0 0.0]
          [0.0 (1.0 / disp-info.scale.xorg) 0.0]
          [0.0 0.0 1.0]
        ];
      }) prof-value;
    }) cfg.profiles;
  };
}

{ config, ... }:

{
  imports = [
    ./evremap.nix
    ./tiny-dfr.nix
  ];

  config = {
    # configure keyboard to use colemak
    services.xserver = {
      xkb = {
        layout = "us";
        variant = "colemak";
        options = "caps:escape";
      };
    };

    # ... and to overload caps-lock with esc/ctrl behavior
    modules.input.evremap = {
      enable = true;
      profiles = let
        dual_role = [
          {
            input = "KEY_CAPSLOCK";
            tap = ["KEY_ESC"];
            hold = ["KEY_LEFTCTRL"];
          }
        ];
      in {
        internal = with config.sysinfo.keyboard-management; {
          device_name = internal-kbd-name;
          remap = internal-kbd-remap;
          inherit dual_role;
        };
        saka = {
          device_name = "CMM.Studio Saka68";
          inherit dual_role;
        };
      };
    };

    # enable tiny-dfr, a touchbar daemon, on asahi linux
    modules.input.tiny-dfr.enable = config.sysinfo.asahi;
  };
}

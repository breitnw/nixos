{
  inputs,
  pkgs,
  ...
}: {
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
        internal = {
          device_name = "Apple SPI Keyboard";
          inherit dual_role;
        };
        external = {
          device_name = "CMM.Studio Saka68";
          inherit dual_role;
        };
      };
    };

    # enable tiny-dfr, a touchbar daemon
    modules.input.tiny-dfr.enable = true;
  };
}

{lib, ...}: {
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
        devices = [
          "CMM.Studio Saka68"
          "Apple SPI Keyboard"
        ];
        dual_role = [
          {
            input = "KEY_CAPSLOCK";
            tap = ["KEY_ESC"];
            hold = ["KEY_LEFTCTRL"];
          }
        ];
      in (map (device_name: {
          inherit device_name dual_role;
        })
        devices);
    };

    # enable tiny-dfr, a touchbar daemon
    modules.input.tiny-dfr.enable = true;
  };
}

# HP Laptop 14t-dq200

{
  platform = {
    type = "x86_64-linux";
    asahi = false;

    # features (mainly graphics) available on this system
    available-features = {
      vsync = true;
      gamma-ramp = true;
      dp-alt-mode = true;
    };

    # internal keyboard information
    keyboard-management = {
      internal-kbd-name = "AT Translated Set 2 keyboard";
      internal-kbd-remap = [
        { input = [ "KEY_LEFTALT" ]; output = [ "KEY_LEFTMETA" ]; }
        { input = [ "KEY_LEFTMETA" ]; output = [ "KEY_LEFTALT" ]; }
      ];
    };

    # display and display profile information
    display-management = {
      displays = {
        eDP-1 = {
          fingerprint = "00ffffffffffff0006af991900000000341e0104951f117802c0d58f5658932920505400000001010101010101010101010101010101ce1d56e250001e302616360035ad10000018df1356e250001e302616360035ad1000001800000000000000000000000000000000000000000002001048ff0f3c7d1f1222c4202020008e";
          pixel-size.width = 1366;
          pixel-size.height = 768;
          scale.xorg = 1.0;
          scale.wayland = 1.0;
        };
        # HDMI-1 = {
        #   fingerprint = "?";
        #   pixel-size.width = 2560;
        #   pixel-size.height = 1440;
        #   scale.xorg = 1;
        #   scale.wayland = 1;
        # };
      };
      profiles.mobile = {
        eDP-1 = {
          primary = true;
          position = "0x0";
        };
      };
      # profiles.docked = {
      #   eDP-1 = {
      #     position = "0x241";
      #   };
      #   HDMI-1 = {
      #     primary = true;
      #     position = "1366x0";
      #   };
      # };
    };
  };
}

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
    display-profiles = let
      internal = {
        # output = "eDP-1";
        fingerprint = "00ffffffffffff0006af991900000000341e0104951f117802c0d58f5658932920505400000001010101010101010101010101010101ce1d56e250001e302616360035ad10000018df1356e250001e302616360035ad1000001800000000000000000000000000000000000000000002001048ff0f3c7d1f1222c4202020008e";
        pixel-size.width = 1366;
        pixel-size.height = 768;
        scale.xorg = 1.0;
        scale.wayland = 1.0;
      };
      # HP 27q
      hp-27q = {
        # output = "HDMI-1";
        fingerprint = "00ffffffffffff00220e653501010101181e0103803c22782aa595a65650a0260d5054254b00d1c0a9c081c0d100b30095008100a940565e00a0a0a029503020350055502100001a000000fd00324c1e5a1b000a202020202020000000fc004850203237710a202020202020000000ff00434e4b303234315636500a202001e8020319b14910040302011112131f67030c0010000036e2002b023a801871382d40582c450055502100001e023a80d072382d40102c458055502100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091";
        pixel-size.width = 2560;
        pixel-size.height = 1440;
        scale.xorg = 1.0;
        scale.wayland = 1.0;
      };
      # Small Dell monitor
      dell = {
        # output = "HDMI-1";
        fingerprint = "00ffffffffffff0010ac0ba053384c30210e010380221b78eecaf6a357479e23114f54a54b00714f8180010101010101010101010101302a009851002a4030701300520e1100001e000000ff005534393331343844304c38530a000000fc0044454c4c204531373346500a20000000fd00384b1f500e000a202020202020019502031b61230907078301000067030c002000802d43908402e2000f8c0ad08a20e02d10103e9600a05a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000029";
        pixel-size.width = 1280;
        pixel-size.height = 1024;
        scale.xorg = 1.0;
        scale.wayland = 1.0;
      };
    in {
      mobile = {
        eDP-1 = {
          primary = true;
          position = "0x0";
          display = internal;
        };
      };
      dell-docked = {
        eDP-1 = {
          position = "0x241";
          display = internal;
        };
        HDMI-1 = {
          primary = true;
          position = "1366x0";
          display = dell;
        };
      };
      dell-closed = {
        HDMI-1 = {
          primary = true;
          position = "0x0";
          display = dell;
        };
      };
      hp-27q-docked = {
        eDP-1 = {
          position = "0x241";
          display = internal;
        };
        HDMI-1 = {
          primary = true;
          position = "1366x0";
          display = hp-27q;
        };
      };
      hp-27q-closed = {
        HDMI-1 = {
          primary = true;
          position = "0x0";
          display = hp-27q;
        };
      };
    };
  };
}

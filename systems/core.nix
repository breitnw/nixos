{
  sysinfo = {
    system = "aarch64-linux";
    asahi = true;
    available-features = {
      vsync = false;
      gamma-ramp = false;
      dp-alt-mode = false;
    };
    # internal keyboard information
    keyboard-management = {
      internal-kbd-name = "Apple SPI Keyboard";
    };
    # display and display profile information
    display-management = {
      displays = {
        eDP-1 = {
          fingerprint = "--CONNECTED-BUT-EDID-UNAVAILABLE--eDP-1";
          pixel-size.width = 2560;
          pixel-size.height = 1600;
          scale.xorg = 2.0;
          scale.wayland = 1.5;
        };
        DVI-I-1-1 = {
          fingerprint = "00ffffffffffff00220e653501010101181e0103803c22782aa595a65650a0260d5054254b00d1c0a9c081c0d100b30095008100a940565e00a0a0a029503020350055502100001a000000fd00324c1e5a1b000a202020202020000000fc004850203237710a202020202020000000ff00434e4b303234315636500a202001e8020319b14910040302011112131f67030c0010000036e2002b023a801871382d40582c450055502100001e023a80d072382d40102c458055502100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091";
          pixel-size.width = 2560;
          pixel-size.height = 1440;
          scale.xorg = 1.0;
          scale.wayland = 1.0;
        };
      };
      profiles.mobile = {
        eDP-1 = {
          primary = true;
          position = "0x0";
        };
      };
      profiles.docked = {
        eDP-1 = {
          position = "0x241";
        };
        DVI-I-1-1 = {
          primary = true;
          position = "1280x0";
        };
      };
    };
  }; 
}

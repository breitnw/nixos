{ ... }:

{
  imports = [ ./options.nix ];

  config = {
    services.autorandr-custom = {
      enable = true;
      profiles = {
        mobile = {
          fingerprint = { eDP-1 = "--CONNECTED-BUT-EDID-UNAVAILABLE--eDP-1"; };
          config = {
            DVI-I-1-1 = { enable = false; };
            eDP-1 = {
              primary = true;
              crtc = 0;
              mode = "2560x1600";
              position = "0x0";
              rate = "60.00";
              filter = "nearest";
              transform = [ [ 0.5 0.0 0.0 ] [ 0.0 0.5 0.0 ] [ 0.0 0.0 1.0 ] ];
            };
          };
        };
        docked = {
          fingerprint = {
            DVI-I-1-1 =
              "00ffffffffffff00220e653501010101181e0103803c22782aa595a65650a0260d5054254b00d1c0a9c081c0d100b30095008100a940565e00a0a0a029503020350055502100001a000000fd00324c1e5a1b000a202020202020000000fc004850203237710a202020202020000000ff00434e4b303234315636500a202001e8020319b14910040302011112131f67030c0010000036e2002b023a801871382d40582c450055502100001e023a80d072382d40102c458055502100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091";
            eDP-1 = "--CONNECTED-BUT-EDID-UNAVAILABLE--eDP-1";
          };
          config = {
            DVI-I-1-1 = {
              primary = true;
              crtc = 1;
              mode = "2560x1440";
              position = "0x0";
              rate = "59.95";
            };
            eDP-1 = {
              crtc = 0;
              mode = "2560x1600";
              position = "2560x207";
              rate = "60.00";
              filter = "nearest";
              transform = [ [ 0.5 0.0 0.0 ] [ 0.0 0.5 0.0 ] [ 0.0 0.0 1.0 ] ];
            };
          };
        };
        docked_lid_closed = {
          fingerprint = {
            DVI-I-1-1 =
              "00ffffffffffff00220e653501010101181e0103803c22782aa595a65650a0260d5054254b00d1c0a9c081c0d100b30095008100a940565e00a0a0a029503020350055502100001a000000fd00324c1e5a1b000a202020202020000000fc004850203237710a202020202020000000ff00434e4b303234315636500a202001e8020319b14910040302011112131f67030c0010000036e2002b023a801871382d40582c450055502100001e023a80d072382d40102c458055502100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091";
          };
          config = {
            DVI-I-1-1 = {
              primary = true;
              crtc = 1;
              mode = "2560x1440";
              position = "0x0";
              rate = "59.95";
            };
            eDP-1 = { enable = false; };
          };
        };
      };
    };
  };
}

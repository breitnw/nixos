{
  config,
  lib,
  pkgs,
  ...
}: let
  userName = "breitnw";
  remote = "https://cal.mndco11age.xyz";
  calendars = {
    classes = {
      id = "05c1abae-04ae-7c3c-6424-dbcb66b4e9a4";
      color = "dark green";
    };
    clubs = {
      id = "3dcdba38-60a3-3005-4243-93fcec8ce978";
      color = "dark cyan";
    };
    meetings = {
      id = "ba5d2c92-5382-8c25-f30f-5267a413f9f9";
      color = "brown";
    };
    stuff = {
      id = "b418ade2-7d26-c0c6-3a65-102cec6f0392";
      color = "dark red";
    };
    volunteering = {
      id = "e011c882-cbb6-2b85-ae30-b554980a2a58";
      color = "dark magenta";
    };
  };
in {
  accounts.calendar = {
    basePath = "Calendar";
    accounts =
      builtins.mapAttrs (name: value: {
        inherit name;
        remote = {
          type = "caldav";
          inherit userName;
          passwordCommand = ["cat" config.sops.secrets."accounts/caldav/${userName}".path];
          url = "${remote}/${userName}/${value.id}/";
        };
        khal = {
          enable = true;
          inherit (value) color;
        };
        vdirsyncer = {enable = true;};
      })
      calendars;
  };
  programs.khal = {
    enable = true;
    package = pkgs.khal;
    locale.dateformat = "%m-%d";
    locale.timeformat = "%H:%M";
    locale.firstweekday = 6;
    settings = {
      default.highlight_event_days = true;
      keybindings = with config.utils.keybinds; {
        new = "c";
        left = vi.left;
        down = vi.down;
        up = vi.up;
        right = vi.right;
      };
      palette = {
        "edit" = "white, dark gray, default, white, '#${config.colorscheme.palette.base01}'";
        "edit focus" = "white, dark gray, default, white, '#${config.colorscheme.palette.base02}'";
        "button" = "white, dark green, default, default, '#${config.colorscheme.palette.base03}'";
        "button focused" = "white, light green, default, default, '#${config.colorscheme.palette.base04}'";
        "editbx" = "white, light green, default, default, '#${config.colorscheme.palette.base04}'";
      };
    };
  };
  programs.vdirsyncer = {
    enable = true;
    statusPath = config.accounts.calendar.basePath;
  };
  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/5";
  };
}

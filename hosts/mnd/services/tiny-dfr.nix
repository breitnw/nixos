# Touchbar support service
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.tiny-dfr;
in {
  options = {
    services.tiny-dfr = {
      enable = lib.mkEnableOption "Enable tiny-dfr service";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.tiny-dfr;
        defaultText = "pkgs.tiny-dfr";
        description = "Set version of tiny-dfr package to use";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services."tiny-dfr" = {
      description = "Touchbar daemon";
      wantedBy = ["multi-user.target"];
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "plymouth-quit.service"
        "systemd-logind.service"
      ];

      restartIfChanged = false;

      serviceConfig = {
        # should automatically be interpolated, installing tiny-dfr
        ExecStart = "${cfg.package}/bin/tiny-dfr";
        Restart = "always";

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateIPC = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = "strict";
        RestrictAddressFamilies = ["AF_UNIX" "AF_NETLINK"];
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        DynamicUser = false; # run as sudo
      };
    };
    # https://github.com/AsahiLinux/tiny-dfr/blob/master/share/tiny-dfr/config.toml
    environment.etc."tiny-dfr/config.toml".text = ''
      MediaLayerDefault = true
      ShowButtonOutlines = true
      AdaptiveBrightness = true
      FontTemplate = "Monospace"
      MediaLayerKeys = [
        { Icon = "brightness_low",  Action = "BrightnessDown", Stretch = 2},
        { Icon = "brightness_high", Action = "BrightnessUp",   Stretch = 2},
        { Icon = "backlight_low",   Action = "IllumDown",      Stretch = 2},
        { Icon = "backlight_high",  Action = "IllumUp",        Stretch = 2},
        { Icon = "fast_rewind",     Action = "PreviousSong",   Stretch = 2},
        { Icon = "play_pause",      Action = "PlayPause",      Stretch = 2},
        { Icon = "fast_forward",    Action = "NextSong",       Stretch = 2},
        { Icon = "volume_off",      Action = "Mute",           Stretch = 2},
        { Icon = "volume_down",     Action = "VolumeDown",     Stretch = 2},
        { Icon = "volume_up",       Action = "VolumeUp",       Stretch = 2},
        { Battery = "icon",         Action = "Battery",        Stretch = 1},
        { Time = "%I:%M %p",        Action = "Time",           Stretch = 3},
      ]
    '';
  };
}

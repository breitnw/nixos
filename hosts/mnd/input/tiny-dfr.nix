# Touchbar support service
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.input.tiny-dfr;
in {
  options = {
    modules.input.tiny-dfr = {
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
    # TODO look at https://github.com/basecamp/omarchy/issues/1840
    hardware.apple.touchBar = {
      enable = true;
      package = cfg.package;
      settings = {
        MediaLayerDefault = true;
        ShowButtonOutlines = true;
        AdaptiveBrightness = true;
        FontTemplate = "Monospace";
        # MediaLayerKeys = [
        #   { Icon = "brightness_low";  Action = "BrightnessDown"; Stretch = 2;}
        #   { Icon = "brightness_high"; Action = "BrightnessUp";   Stretch = 2;}
        #   { Icon = "backlight_low";   Action = "IllumDown";      Stretch = 2;}
        #   { Icon = "backlight_high";  Action = "IllumUp";        Stretch = 2;}
        #   { Icon = "fast_rewind";     Action = "PreviousSong";   Stretch = 2;}
        #   { Icon = "play_pause";      Action = "PlayPause";      Stretch = 2;}
        #   { Icon = "fast_forward";    Action = "NextSong";       Stretch = 2;}
        #   { Icon = "volume_off";      Action = "Mute";           Stretch = 2;}
        #   { Icon = "volume_down";     Action = "VolumeDown";     Stretch = 2;}
        #   { Icon = "volume_up";       Action = "VolumeUp";       Stretch = 2;}
        #   { Battery = "icon";         Action = "Battery";        Stretch = 1;}
        #   { Time = "%I:%M %p";        Action = "Time";           Stretch = 3;}
        # ];
      };
    };
  };
}

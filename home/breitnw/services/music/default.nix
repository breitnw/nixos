{
  pkgs,
  config,
  lib,
  ...
}:
# TODO use a program like mpdpopm or mpdfav for favorites
{
  services.mpd = {
    enable = true;
    musicDirectory = "~/Music/";
    # pulseaudio seems to be necessary to not blow out my eardrums
    extraConfig = ''
      audio_output {
        type    "pulse"
        name    "My MPD PulseAudio Output"
        #server  "localhost"   # optional
        #sink    "alsa_output" # optional
        }
      bind_to_address "/tmp/mpd_socket"
    '';
  };
  home.packages = [
    pkgs.unstable.rmpc
  ];
  # the rmpc module in home-manager doesn't have the themes directory :(
  xdg.configFile.rmpc = {
    source = ./rmpc;
    recursive = true;
  };
}

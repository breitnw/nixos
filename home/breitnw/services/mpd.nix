{pkgs, ...}:
# TODO move rmpc config to nix
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
  home.packages = with pkgs; [
    rmpc
    ueberzugpp
  ];
}

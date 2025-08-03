{pkgs, ...}:
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
  xdg.configFile = let
    rmpc-bin = "${pkgs.rmpc}/bin/rmpc";
    jq-bin = "${pkgs.jq}/bin/jq";
    rmpc-toggle-favorite = pkgs.writeShellScriptBin "rmpc-toggle-favorite" ''
      IFS=$'\n' # make newlines the only separator
      for SONG in $SELECTED_SONGS; do
        sticker=$(${rmpc-bin} sticker get "$SONG" "favorited" | ${jq-bin} -r '.value')

        if [ -z "$sticker" ]; then
          ${rmpc-bin} sticker set "$SONG" "favorited" "★"
        else
          ${rmpc-bin} sticker delete "$SONG" "favorited"
        fi
      done
    '';
    rmpc-toggle-favorite-bin = "${rmpc-toggle-favorite}/bin/rmpc-toggle-favorite";
  in {
    "rmpc/config.ron".source = pkgs.replaceVars ./rmpc/config.ron {
      rmpc-toggle-favorite = rmpc-toggle-favorite-bin;
    };
    "rmpc/themes" = {
      source = ./rmpc/themes;
      recursive = true;
    };
  };
}

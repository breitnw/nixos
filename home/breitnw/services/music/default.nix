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
    # for marking favorite songs: rmpc-toggle-favorite
    rmpc-bin = "${pkgs.rmpc}/bin/rmpc";
    jq-bin = "${pkgs.jq}/bin/jq";
    rmpc-toggle-favorite = pkgs.writeShellScript "rmpc-toggle-favorite" ''
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

    # send a notification on song change: rmpc-notify
    notify-send-bin = "${pkgs.libnotify}/bin/notify-send";
    rmpc-notify = pkgs.writeShellScript "rmpc-notify" ''
      TMP_DIR="/tmp/rmpc"
      mkdir -p "$TMP_DIR"
      ALBUM_ART_PATH="$TMP_DIR/notification_cover"
      DEFAULT_ALBUM_ART_PATH="$TMP_DIR/default_album_art.jpg"
      if ! ${rmpc-bin} albumart --output "$ALBUM_ART_PATH"; then
          ALBUM_ART_PATH="$DEFAULT_ALBUM_ART_PATH"
      fi
      ${notify-send-bin} -i "$ALBUM_ART_PATH" "Now Playing" "$ARTIST - $TITLE"
    '';
  in {
    "rmpc/config.ron".source = pkgs.replaceVars ./rmpc/config.ron {
      inherit rmpc-toggle-favorite rmpc-notify;
    };
    "rmpc/themes" = {
      source = ./rmpc/themes;
      recursive = true;
    };
  };
}

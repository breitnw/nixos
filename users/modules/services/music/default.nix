{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.music.enable = lib.mkEnableOption "whether to enable mpd and rmpc";
  };
  config = let
    mpd_socket_path = "/tmp/mpd_socket";
  in lib.mkIf config.modules.music.enable {
    # enables media control keys, etc
    services.mpdris2-rs = {
      enable = true;
      host = mpd_socket_path;
      notifications.enable = true;
    };
    services.mpd = {
      enable = true;
      # sync music with rclone
      # musicDirectory = config.programs.rclone.remotes.copyparty.mounts."private/music/library".mountPoint; 
      musicDirectory = "https://copyparty.mndco11age.xyz/music"; 
      # do not maintain a db file on local; use satellite instead
      dbFile = null;
      # stickers/playlists must be on local (https://github.com/MusicPlayerDaemon/MPD/issues/848)
      dataDir = "${config.xdg.dataHome}/mpd";

      # pulseaudio seems to be necessary to not blow out my eardrums
      # cloudflare is proxied, so mpd can't be accessed behind mndco11age.xyz
      extraConfig = ''
        audio_output {
          type "pulse"
          name "MPD PulseAudio Output"
        }
        database {
          plugin "proxy"
          host "breitnw.duckdns.org"
          port "6600"
        }
        bind_to_address "/tmp/mpd_socket"
      '';
    };
    home.packages = [
      pkgs.rmpc

      # try to raise the rmpc window if one exists before creating a new one,
      # since I tend to the command to open it a lot
      (pkgs.writeShellScriptBin "launch-rmpc" ''
        RMPC=$(${pkgs.wmctrl}/bin/wmctrl -l -x | awk -F " " '{print $3}' | grep rmpc)
      if [[ -n $RMPC ]]; then
        ${pkgs.wmctrl}/bin/wmctrl -x -a rmpc.rmpc
      else
        ${config.programs.alacritty.package}/bin/alacritty --title rmpc --class rmpc -e rmpc
      fi
      '')
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

    in {
      "rmpc/config.ron".source = pkgs.replaceVars ./rmpc/config.ron {
        inherit rmpc-toggle-favorite;
      };
      "rmpc/themes" = {
        source = ./rmpc/themes;
        recursive = true;
      };
    };
  };
}

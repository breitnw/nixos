{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    modules.rclone = {
      enable = lib.mkEnableOption "Whether to enable the rclone service";
    };
  };
  config = lib.mkIf config.modules.rclone.enable {

    # sync org directory, making a backup each time
    systemd.user = let
      remote-name = "copyparty";
      org-local = "~/Documents/org";
      org-remote = "private/org";
      replaceSlashes = builtins.replaceStrings ["/"] ["."];
      sync-script = pkgs.writeShellScript
        "rclone-sync-script:${replaceSlashes org-remote}@${remote-name}"
        (lib.concatStringsSep " " [
          (lib.getExe config.programs.rclone.package)
          "sync"
          org-local
          "${remote-name}:${org-remote}/current"
          "--delete-excluded"
          "--exclude"
          "org-tex-*"
          "--backup-dir"
          "${remote-name}:${org-remote}/backups/$(${pkgs.coreutils}/bin/date +'%Y-%m-%dT%H%M%S%z')"
        ]);
    in {
      timers."rclone-sync:${replaceSlashes org-remote}@${remote-name}" = {
        Unit = {
          Description = "Timer to backup org directory using rclone";
        };
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };
        Install.WantedBy = ["timers.target"];
      };
      services."rclone-sync:${replaceSlashes org-remote}@${remote-name}" = {
        Unit = {
          Description = "Backup org directory using rclone";
        };
        Service = {
          Type = "oneshot";
          Environment = ["PATH=/run/wrappers/bin"];
          ExecStart = sync-script;
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };
    };

    # all other directories are mounts
    programs.rclone = {
      enable = true;
      remotes.copyparty = {
        config = {
          type = "webdav";
          url = "https://copyparty.mndco11age.xyz";
          vendor = "owncloud";
          pacer_min_sleep = "0.01ms";
          user = "breitnw";
        };
        secrets = {
          pass = config.sops.secrets."accounts/copyparty/breitnw".path;
        };
        mounts = {
          "private/music/library" = {
            enable = true;
            options = {
              async-read = true; # read asynchronously for better performance
              dir-cache-time = "72h"; # cache directory structure for 3 days
              vfs-cache-mode = "full"; # allow file caching
              vfs-cache-max-size = "50G"; # music should have a generous cache
              vfs-cache-poll-interval = "5m"; # check the cache every 5 min
              vfs-cache-max-age = "1w";
              vfs-fast-fingerprint = true;
              vfs-read-chunk-size = "512M"; # initial chunk read size
              # vfs-read-chunk-size-limit = "5G"; # double chunk size up to 5G
              tpslimit = 10;
              tpslimit-burst = 20;
              # I don't think we need buffer-size and vfs-read-ahead unless streaming
            };
            mountPoint = "${config.home.homeDirectory}/Music";
          };
          "private" = {
            enable = true;
            options = {
              dir-cache-time = "5m";
              vfs-cache-mode = "full";
              vfs-cache-poll-interval = "5m";
              vfs-cache-max-size = "5G";
            };
            mountPoint = "${config.home.homeDirectory}/Copyparty";
          };
        };
      };
    };
  };
}

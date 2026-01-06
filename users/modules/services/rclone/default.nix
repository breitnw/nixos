{
  config,
  lib,
  ...
}: {
  imports = [
    ./options.nix
  ];
  options = {
    modules.rclone = {
      enable = lib.mkEnableOption "Whether to enable the rclone service";
    };
  };
  config = lib.mkIf config.modules.rclone.enable {
    programs.rclone-custom = {
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
        syncs = {
          "private/org" = {
            enable = true;
            localDir = "${config.home.homeDirectory}/Documents/org";
          };
        };
        mounts = {
          # "private/org" = {
          #   enable = true;
          #   options = {
          #     vfs-cache-mode = "full";
          #     dir-cache-time = "1m";
          #   };
          #   mountPoint = "${config.home.homeDirectory}/Documents/org";
          # };
          "public/music" = {
            enable = true;
            options = {
              async-read = true; # read asynchronously for better performance
              dir-cache-time = "72h"; # cache directory structure for 3 days
              vfs-cache-mode = "full"; # allow file caching
              vfs-cache-max-size = "50G"; # music should have a generous cache
              vfs-cache-poll-interval = "5m"; # check the cache every 5 min
              vfs-fast-fingerprint = true;
              vfs-read-chunk-size = "512M"; # initial chunk read size
              # vfs-read-chunk-size-limit = "5G"; # double chunk size up to 5G
              tpslimit = 10;
              tpslimit-burst = 20;
              # I don't think we need buffer-size and vfs-read-ahead unless streaming
            };
            mountPoint = "${config.home.homeDirectory}/Music";
          };
        };
      };
    };
  };
}

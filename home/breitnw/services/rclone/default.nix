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
        backSyncs = {
          "public/music" = {
            enable = true;
            # Don't sync directly to ~/Music, since I want ~/Music to be
            # read-only. Instead, create a read-only bind mount:
            #  mount --bind "${config.dataHome}/music-back-sync" ~/Music
            #  mount -o bind,remount,ro ~/Music
            dataDir = "${config.xdg.dataHome}/music-back-sync";
            mountDir = "${config.home.homeDirectory}/Music";
          };
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
          # "public/music" = {
          #   enable = true;
          #   options = {
          #     vfs-cache-mode = "full";
          #   };
          #   mountPoint = "${config.home.homeDirectory}/Music";
          # };
        };
      };
    };
  };
}

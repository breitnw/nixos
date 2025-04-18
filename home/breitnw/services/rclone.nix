{ pkgs, config, lib, ... }: {
  options = {
    modules.rclone = {
      enable = lib.mkEnableOption "Whether to enable the rclone service";
    };
  };
  config = lib.mkIf config.modules.rclone.enable {
    home.packages = [ pkgs.rclone ];
    sops.templates."rclone.conf" = {
      content = ''
        [WebDAV]
        type = webdav
        url = https://dav.mndco11age.xyz
        vendor = other
        user = breitnw
        pass = ${config.sops.placeholder."accounts/webdav/breitnw"}
      '';
    };

    systemd.user.services.rclone = {
      Unit = {
        Description = "Automatic mounting of WebDAV share with rclone";
        After = [ "network-online.target" ];
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/usr/bin/env mkdir -p %h/WebDAV";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone mount WebDAV:/ /home/breitnw/WebDAV/ --config="${
            config.sops.templates."rclone.conf".path
          }" --vfs-cache-mode full --allow-non-empty'';
        ExecStop = "/bin/fusermount -u %h/WebDAV/%i";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}

{config, ...}: {
  programs.hm-ricing-mode = {
    enable = true;
    apps = {
      rmpc.dest_dir = ".config/rmpc";
      fastfetch.dest_dir = ".config/fastfetch";
    };
  };
}

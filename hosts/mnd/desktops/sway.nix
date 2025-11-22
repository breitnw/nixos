{
  lib,
  config,
  ...
}: {
  options = {
    desktops.sway.enable = lib.mkEnableOption "Whether to enable the Sway desktop";
  };

  config = lib.mkIf config.desktops.sway.enable {
    # So that sway shows up in greetd. All of the actual configuration for Sway
    # is done in home-manager
    programs.sway.enable = true;
  };
}

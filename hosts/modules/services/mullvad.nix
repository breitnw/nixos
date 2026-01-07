{ config, lib, ... }:

{
  options = {
    modules.mullvad.enable = lib.mkEnableOption "Whether to enable the Mullvad daemon";
  };
  config = {
    services.mullvad-vpn.enable = true;

    # automatically connect on startup
    systemd.services."mullvad-daemon".postStart = let
      mullvad = config.services.mullvad-vpn.package;
    in ''
      while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 1; done
      ${mullvad}/bin/mullvad auto-connect set on
    '';
  };
}

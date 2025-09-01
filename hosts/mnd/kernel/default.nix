{pkgs, ...}: {
  config = {
    # Configure the peripheral firmware directory
    # The original can be found at /boot/asahi/
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;

    hardware.graphics.enable = true;
    hardware.graphics.package = pkgs.unstable.mesa;
  };
}

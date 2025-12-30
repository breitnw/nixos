{config, ...}:

{
  # Enable asahi if needed by the system
  hardware.asahi.enable = config.sysinfo.asahi;

  # Configure the peripheral firmware directory
  # The original can be found at /boot/asahi/
  # hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
}

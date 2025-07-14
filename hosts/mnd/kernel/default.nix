{...}: {
  config = {
    # Configure the peripheral firmware directory
    # The original can be found at /boot/asahi/
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;

    hardware.asahi.useExperimentalGPUDriver = true;
    hardware.graphics.enable = true;
  };
}

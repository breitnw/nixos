{ ... }:

{
  imports = [
    ./apple-silicon-support
    ./displaylink
  ];

  config = {
    # Configure the peripheral firmware directory
    # The original can be found at /boot/asahi/
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  };
}

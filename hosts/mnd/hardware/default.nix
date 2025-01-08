{ ... }:

let
  # fetch asahi linux support modules from the nixos-apple-silicon github
  asahi = builtins.fetchGit {
    url = "git@github.com:tpwrules/nixos-apple-silicon.git";
    rev = "3daf0637409689d7a1304cedc50d20542bc47905";
  };
in {
  imports = [
    ./display-support
    "${asahi}/apple-silicon-support"
  ];

  config = {
    # Configure the peripheral firmware directory
    # The original can be found at /boot/asahi/
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;
    hardware.asahi.useExperimentalGPUDriver = true;
    hardware.graphics.enable = true;
  };
}

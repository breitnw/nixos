{ ... }:

let
  # fetch asahi linux support modules from the nixos-apple-silicon github
  asahi = builtins.fetchGit {
    url = "git@github.com:tpwrules/nixos-apple-silicon.git";
    rev = "e8c07c3ae199b55a8c1c35a7c067c5cef9c7e929";
  };
in {
  imports = [
    ./displaylink.nix
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

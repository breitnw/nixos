# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, inputs, lib, config, ... }:

{
  imports = [
    # Input devices, such as the keyboard and touchbar
    ./input
    # Output devices, such as displays and audio devices
    ./output
    # Desktop environment and display manager
    ./desktops
    # Kernel stuff, including apple silicon support
    ./kernel
  ];

  # location service
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  powerManagement.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.package = pkgs.mesa;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  console.useXkbConfig = true; # use xkb.options in tty.

  # Enable CUPS to print documents.
  services.printing.enable = true;

  nix = {
    # Enable flakes
    settings.experimental-features = ["nix-command" "flakes"];
    # Enable automatic garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    # Enable automatic optimization
    optimise.automatic = true;
    # ensure that nixpkgs path aligns with nixpkgs flake input
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {PasswordAuthentication = false;};
  };

  # Open ports in the firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [57110];
  };
}

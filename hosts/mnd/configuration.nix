# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan [built automatically]
    ./hardware-configuration.nix
    # Apple silicon support
    ./kernel
    # Input devices, such as the keyboard and touchbar
    ./input
    # Output devices, such as displays and audio devices
    ./output
    # Desktop environment and display manager
    ./desktops
  ];

  # required udev rules for platformio
  services.udev.packages = [pkgs.platformio-core.udev];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable automatic optimization and garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # Networking
  networking.hostName = "mnd";
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  console.useXkbConfig = true; # use xkb.options in tty.

  # from https://discourse.nixos.org/t/xdg-desktop-portal-gtk-desktop-collision/35063
  # xdg desktop portals expose d-bus interfaces for xdg file access
  # are needed by some containerized apps like firefox.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Configure users
  users.mutableUsers = false;
  users.users.breitnw = {
    hashedPassword = "$y$j9T$sjn2BP/Vf7c/YuzYdQ/0K0$mq/EbgLp0/BLODW5uLM0f6agAeqrue65Nc25KUCM8XB";
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager" # Allow the user to access the network manager
      "audio" # Needed for supercollider/tidal
      "jackaudio" # Needed for services.jack (I think)
      "video"
      "input" # above needed for brightnessctl
    ];
  };

  # Configure system packages
  # STYLE: This should only contain packages necessary for commands/services
  #  run as root, or for system recovery in an emergency. All other packages
  #  should be configured via home-manager on a per-user basis
  environment.systemPackages = with pkgs; [vim wget];

  # ensure that nixpkgs path aligns with nixpkgs flake input
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions. For more information,
  # see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

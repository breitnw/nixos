# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  # config,
  pkgs,
  inputs,
  ...
}:

{
  imports =
    [
      # Include the results of the hardware scan [built automatically]
      ./hardware-configuration.nix
      # Apple silicon hardware support
      ./hardware
      # Systemd services to be run as root
      ./services
      # Desktop environment support
      ./desktop-support
      # Secrets management with sops-nix
      ./secrets
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking.hostName = "mnd";
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # External displays
  # hardware.displaylink.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console.useXkbConfig = true; # use xkb.options in tty.

  # Enable the X11 windowing system and configure XFCE

  # TODO use an enum
  # Enable xfce
  desktops.xfce.enable = true;
  # don't enable KDE
  desktops.kde.enable = false;

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "colemak";
      options = "caps:escape";
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # Pipewire is enabled in apple-silicon-support/modules/sound/default.nix

  # Enable touchpad support (enabled default in most desktopManager).
  # -- ENABLED BY DEFAULT in xfce
  # services.libinput.enable = true;

  # Configure users
  users.mutableUsers = false;
  users.users.breitnw = {
    hashedPassword = "$y$j9T$sjn2BP/Vf7c/YuzYdQ/0K0$mq/EbgLp0/BLODW5uLM0f6agAeqrue65Nc25KUCM8XB";
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager" # Allow the user to access the network manager
      "input" # Enable libinput-gestures for the user
    ];
  };

  # Configure system packages
  # STYLE: This should only contain packages necessary for commands/services run as root,
  #  or for system recovery in an emergency. All other packages should be configured via
  #  home-manager on a per-user basis
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # ensure that nixpkgs path aligns with nixpkgs flake input
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Enable the touch bar with tiny-dfr
  services.tiny-dfr = {
    enable = true;
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}


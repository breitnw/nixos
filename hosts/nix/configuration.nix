# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Apple silicon drivers
      ./apple-silicon-support
      # Systemd services to be run as root
      ./services
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Configure the peripheral firmware directory
  # The original can be found at /boot/asahi/
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "America/Chicago";
  time.timeZone = "Asia/Beijing";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    xkb = {
      layout = "us";
      variant = "colemak";
      options = "caps:escape";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # -- ENABLED BY DEFAULT in xfce
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

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
    # packages = with pkgs; [
    #   firefox
    #   tree
    #   neofetch
    #   kitty
    #   sayonara # music player
    # ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget

    # DEVELOPMENT
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # C and C++
    cmake
    libtool
    # Nix
    nil # Nix language server

    # UI/UX
    # TODO: configure gestures so they're actually useful
    # creates user daemon libinput-gestures.service
    # TODO: can this be enabled through config?
    libinput-gestures # touchpad gesture support
    wmctrl # allows libinput-gestures to interact with the window manager
  ];

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}


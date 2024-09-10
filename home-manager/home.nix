{
  # lib,         # the nixpkgs library
  # config,      # the results of all options after merging the values from all modules together
  # options,     # the options declared in all modules
  # specialArgs, # the specialArgs argument passed to evalModules
  pkgs,          # the nixpkgs package set according to the nixpkgs.pkgs option
  ...
}:

{
  imports = [
    ./cli-programs
    ./gui-programs
    ./services
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "breitnw";
    homeDirectory = "/home/breitnw";

    sessionVariables = {
      EDITOR = "emacs";
      FLAKE = "/home/breitnw/NixOS"; # config directory for nh
    };

    packages =  [
      # GUI PROGRAMS ================================
      pkgs.firefox
      pkgs.kitty
      pkgs.sayonara # music player
      pkgs.unstable.ladybird
      pkgs.libreoffice-qt6-fresh
      pkgs.qbittorrent-qt5

      # CLI PROGRAMS ================================
      # random --------------------------------------
      pkgs.neofetch

      # utilities
      pkgs.unzip

      # dev tools -----------------------------------
      pkgs.cmake
      pkgs.rustup
      pkgs.nh # Nix helper
      pkgs.nil # Nix language server
      pkgs.octaveFull # GNU Octave (with gui)

      # LIBRARIES ===================================
      pkgs.libtool # required for vterm-module compilation

      # SERVICES ====================================
      # TODO: configure gestures so they're actually useful
      # creates user daemon libinput-gestures.service
      # TODO: can this be enabled through config?
      pkgs.libinput-gestures # touchpad gesture support
      pkgs.wmctrl # allows libinput-gestures to interact with the window manager
    ];
  };

  xsession.enable = true;

  programs.home-manager.enable = true;
  programs.emacs.enable = true;
  programs.firefox.enable = true;
  programs.bat.enable = true;
  programs.fish.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}

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
    ./desktop
    ./themes
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

    # TODO: does this work?
    # pointerCursor.gtk.enable = true;

    sessionVariables = {
      EDITOR = "emacs";
      FLAKE = "/home/breitnw/NixOS"; # config directory for nh
    };

    packages = [

      # GUI PROGRAMS ================================
      pkgs.firefox
      pkgs.tauon # music player
      pkgs.unstable.ladybird
      pkgs.libreoffice-qt6-fresh
      pkgs.qbittorrent-qt5

      # CLI PROGRAMS ================================
      # random --------------------------------------
      pkgs.neofetch

      # utilities
      pkgs.unzip
      pkgs.pass
      pkgs.ripgrep

      # languages -----------------------------------
      # ...C and C++
      pkgs.gnumake
      pkgs.gcc
      pkgs.cmake
      # ...rust
      pkgs.rustup
      # ...nix
      pkgs.nh # Nix helper
      pkgs.nil # Nix language server
      # ...school
      pkgs.octaveFull # GNU Octave (with gui)
      pkgs.racket_7_9 # racket (and DrRacket)

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

  # builtin programs
  programs.home-manager.enable = true;
  programs.emacs.enable = true;
  programs.firefox.enable = true;
  programs.bat.enable = true;
  programs.fish.enable = true;

  # builtin services
  services.kdeconnect.enable = true;

  # custom modules
  modules.kitty.enable = true;

  # global theme
  theme.name = "Gruvbox";

  # defaults (?)
  xsession.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}

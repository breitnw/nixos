{ pkgs, ... }:
# other options: lib, config, options, specialArgs

{
  imports = [
    ./cli-programs
    ./gui-programs
    ./services
    ./desktop-settings
    ./themes
    ./secrets
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
      FLAKE = "/home/breitnw/Documents/code/nixos"; # config directory for nh
    };

    packages = with pkgs; [
      # GUI PROGRAMS ================================
      firefox
      tauon # music player
      libreoffice-qt6-fresh
      qbittorrent-qt5
      vesktop # discord client
      vscode
      picard

      # CLI PROGRAMS ================================
      neofetch
      unzip
      # pass
      ripgrep
      bat

      # languages -----------------------------------
      # ...C and C++
      gnumake
      gcc
      cmake
      # ...rust
      rustup
      # ...nix
      nh # Nix helper
      nixd # Nix language server
      nixfmt
      # ...latex
      texliveFull
      # ...school
      octaveFull # GNU Octave (with gui)
      racket_7_9 # racket (and DrRacket)

      # FONTS =======================================
      creep
      cozette

      # LIBRARIES ===================================
      libtool # required for vterm-module compilation

      # SERVICES ====================================
      # TODO: configure gestures so they're actually useful
      # creates user daemon libinput-gestures.service
      # TODO: can this be enabled through config?
      libinput-gestures # touchpad gesture support
      wmctrl # allows libinput-gestures to interact with the window manager
    ];
  };

  # builtin programs
  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.emacs.enable = true;

  # builtin services
  services.easyeffects.enable = true;

  # custom modules
  modules.kitty.enable = true;
  modules.redshift.enable = false;
  modules.mail.enable = true;

  # global theme
  theme.name = "Gruvbox";

  # defaults (?)
  xsession.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}

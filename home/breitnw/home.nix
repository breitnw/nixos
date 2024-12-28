{ pkgs, config, ... }:
# other options: lib, options, specialArgs

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
      FLAKE = "${config.home.homeDirectory}/Config/nixos"; # config directory for nh
    };

    packages = with pkgs; [
      # GUI PROGRAMS ================================
      firefox
      tauon # music player
      libreoffice-qt6-fresh
      vesktop # discord client
      vscode
      picard
      superTuxKart
      krita

      # CLI PROGRAMS ================================
      neofetch
      unzip
      # pass
      ripgrep
      bat

      # languages and build tools -------------------
      # ...C and C++
      gnumake
      gcc
      cmake
      pkg-config
      # ...rust
      rustup
      # ...nix
      nh # Nix helper
      unstable.nixd # Nix language server
      nixfmt-classic
      # ...latex
      texliveFull
      # ...python
      python3
      # ...school
      octaveFull # GNU Octave (with gui)
      unstable.racket # racket (and DrRacket)

      # FONTS =======================================
      # to update fonts, it may be necessary to run fc-cache -f
      creep   # used for title bars
      cozette # used for pretty much everything else

      # LIBRARIES ===================================
      libtool # required for vterm-module compilation

      # SERVICES ====================================
      wmctrl # allows libinput-gestures to interact with the window manager
    ];
  };

  # builtin programs
  programs.home-manager.enable = true;
  programs.firefox.enable = true;

  # builtin services
  services.easyeffects.enable = false;

  # custom modules
  modules.alacritty.enable = true;
  modules.redshift.enable = false;
  modules.mail.enable = true;
  modules.pio.enable = true;

  # global theme
  themes.themeName = "Gruvbox";

  # defaults (?)
  xsession.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}

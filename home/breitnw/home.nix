{ pkgs, config, ... }:
# other options: lib, options, specialArgs

# TASKS
# - TODO configure vi keybinds globally and then apply them
#   to emacs, qutebrowser, vi, vim, etc.
# - TODO customizations for generated GTK theme
# - TODO reload emacs theme as soon as config is regenerated (somehow)
# - TODO it seems like cozette has a bunch of glyphs, so why are default
#        nerd fonts being used?
# - TODO customize panel based on whether scheme is light or dark
# - TODO finish figuring out cursor

{
  imports = [
    ./cli-programs
    ./gui-programs
    ./services
    ./desktop-settings
    ./themes
    ./secrets
    ./keybinds
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
      FLAKE = "${config.home.homeDirectory}/Config/nixos"; # config directory for nh
    };

    packages = with pkgs; [
      # GUI PROGRAMS ================================
      firefox
      tauon # music player
      libreoffice-qt6-fresh
      vesktop # discord client
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
  # themes can be previewed at https://tinted-theming.github.io/base16-gallery/

  # themes.themeName = "gruvbox-dark-medium";  # ★ a classic
  # themes.themeName = "darktooth";            # ★ like gruvbox but more purple
  # themes.themeName = "catppuccin-macchiato"; # purple pastel
  # themes.themeName = "darkmoss";             # cool blue-green
  # themes.themeName = "everforest-dark-hard"; # greenish and groovy
  # themes.themeName = "gigavolt";             # dark and vibrant (purply)
  # themes.themeName = "kanagawa";             # ★ blue with yellowed text
  # themes.themeName = "kimber";               # nordish but more red
  # themes.themeName = "mountain";             # ★ dark and moody
  # themes.themeName = "oxocarbon-dark";       # ★ dark and vibrant
  # themes.themeName = "pico";                 # highkey ugly but maybe redeemable
  # themes.themeName = "rose-pine-dawn";       # light and cozy
  themes.themeName = "summercamp";           # ★ earthy but vibrant

  # defaults (?)
  xsession.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}

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
    ./de-settings
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
      tauon # music player
      libreoffice
      vesktop # discord client
      picard
      superTuxKart
      krita

      # CLI PROGRAMS ================================
      neofetch
      unzip
      ripgrep
      bat

      # languages and tools -------------------------
      # ...nix
      nh # Nix helper
      unstable.nixd # Nix language server
      nixfmt-classic
      # ...latex
      texliveFull
      # ...school
      octaveFull # GNU Octave (with gui)

      # LIBRARIES ===================================
      # TODO remove this and install vterm with nix
      # libtool # required for vterm-module compilation
    ];
  };

  # builtin programs
  programs.home-manager.enable = true;
  programs.firefox.enable = true;

  # custom modules
  modules.alacritty.enable = true;
  # modules.redshift.enable = true;
  modules.mail.enable = true;

  # global theme
  # themes can be previewed at https://tinted-theming.github.io/base16-gallery/

  # modules.themes.themeName = "gruvbox-dark-medium";  # ★ a classic
  # modules.themes.themeName = "darktooth";            # ★ like gruvbox but more purple
  # modules.themes.themeName = "catppuccin-macchiato"; # purple pastel
  # modules.themes.themeName = "darkmoss";             # cool blue-green
  # modules.themes.themeName = "everforest-dark-hard"; # greenish and groovy
  # modules.themes.themeName = "gigavolt";             # dark and vibrant (purply)
  # modules.themes.themeName = "kanagawa";             # ★ blue with yellowed text
  # modules.themes.themeName = "kimber";               # nordish but more red
  # modules.themes.themeName = "mountain";             # ★ dark and moody
  # modules.themes.themeName = "oxocarbon-dark";       # ★ dark and vibrant
  # modules.themes.themeName = "pico";                 # highkey ugly but maybe redeemable
  # modules.themes.themeName = "rose-pine-dawn";       # light and cozy
  modules.themes.themeName = "summercamp";           # ★ earthy but vibrant

  # defaults (?)
  xsession.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}

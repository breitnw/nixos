{ pkgs, config, ... }:
# other options: lib, options, specialArgs

# TASKS
# - TODO configure vi keybinds globally and then apply them
#   to emacs, qutebrowser, vi, vim, etc.
# - TODO customizations for generated GTK theme
# - TODO reload emacs theme as soon as config is regenerated (somehow)
# - TODO fetch icon themes from git instead of depending on local state
# - TODO partition cozette with a feature flag or something
# - TODO move sops spec to corresponding modules
# - TODO new design pattern for nix/doom interop: do everything in doom config;
#   only set variables in nix

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
      FLAKE =
        "${config.home.homeDirectory}/Config/nixos"; # config directory for nh
    };

    packages = with pkgs; [
      zotero-nix-grafted

      # GUI PROGRAMS ================================
      libreoffice-qt6
      vesktop # discord client
      picard # music metadata editor
      superTuxKart # epic gaming
      prismlauncher # epic minecraft
      krita # paint
      blender # modeling
      reaper # daw
      aseprite # pixel art tool
      mate.atril # pdf reader
      pinentry-qt

      # CLI PROGRAMS ================================
      fastfetch
      unzip
      ripgrep
      bat

      # languages and tools -------------------------
      # ...nix
      nh # Nix helper
      unstable.nixd # Nix language server
      alejandra
      # ...latex
      texliveFull
      # ...school
      octaveFull # GNU Octave (with gui)

      # FONTS AND OTHER =============================
      etBook
    ];
  };

  # builtin programs
  programs.home-manager.enable = true;

  # custom modules
  modules.alacritty.enable = true;
  modules.mail.enable = true;
  modules.firefox.enable = true;
  modules.qutebrowser.enable = true;
  modules.rclone.enable = false;

  # global theme
  # themes can be previewed at https://tinted-theming.github.io/tinted-gallery/

  # dark themes
  modules.themes = {
    # themeName = "gruvbox-dark-medium";   # ⋆ a classic
    # themeName = "darktooth";             # ⋆ gruvbox but more purply
    # themeName = "catppuccin-macchiato";  # purple pastel
    # themeName = "darkmoss";              # cool blue-green
    # themeName = "everforest-dark-hard";  # greenish and groovy
    # themeName = "gigavolt";              # dark, vibrant, and purply
    # themeName = "kanagawa";              # ⋆ blue with yellowed text
    # themeName = "kimber";                # nordish but more red
    # themeName = "mountain";              # ⋆ dark and moody
    # themeName = "oxocarbon-dark";        # ⋆ dark and vibrant
    # themeName = "pico";                  # highkey ugly but maybe redeemable
    # themeName = "horizon-dark";          # vaporwavey
    # themeName = "summercamp";            # ⋆ earthy but vibrant
    # themeName = "terracotta-dark";       # ⋆ chocolatey and dark
    # themeName = "tarot";                 # very reddish purply
    # themeName = "tokyo-night-dark";      # blue and purple
    # themeName = "zenburn";               # ⋆ grey but in an endearing way
    # themeName = "embers";                # who dimmed the lights
    # themeName = "onedark";               # atom propaganda
    # themeName = "stella";                # purple, pale-ish
    # themeName = "eris";                  # dark blue city lights
    themeName = "darcula";               # ⋆ jetbrains propaganda

    # light themes
    # themeName = "rose-pine-dawn";        # cozy yellow and purple
    # themeName = "horizon-light";         # vaporwavey
    # themeName = "terracotta";            # earthy and bright
    # themeName = "ayu-light";             # kinda pastel
    # themeName = "sagelight";             # more pastel
    # themeName = "classic-light";         # basic and visible
    # themeName = "humanoid-light";        # basic, visible, a lil yellowed
    # themeName = "gruvbox-light-medium";  # it's just gruvbox
  };

  # defaults (?)
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}

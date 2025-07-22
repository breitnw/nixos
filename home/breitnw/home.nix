{
  pkgs,
  config,
  lib,
  ...
}:
# other options: lib, options, specialArgs
# TASKS
# - TODO configure vi keybinds globally and then apply them
#   to emacs, qutebrowser, vi, vim, etc.
# - TODO reload emacs theme as soon as config is regenerated (somehow)
# - TODO fetch icon themes from git instead of depending on local state
# - TODO partition bitmap fonts with a feature flag or something so that i'm not
#   forced to use low-DPI displays into eternity
# - TODO move sops spec to corresponding modules
# - TODO new design pattern for nix/doom interop: do everything in doom config;
#   only set variables in nix
{
  imports = [
    ./programs
    ./services
    ./desktops
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
      NH_FLAKE = "${config.home.homeDirectory}/Config/nixos"; # config directory for nh
    };

    packages = with pkgs; [
      # GUI PROGRAMS ================================
      libreoffice-qt6
      vesktop # discord client
      picard # music metadata editor
      superTuxKart # epic gaming
      prismlauncher # epic minecraft
      krita # paint
      drawing # basic image editing
      gimp # advanced image editing
      blender # modeling
      reaper # daw
      aseprite # pixel art tool
      mate.atril # pdf reader
      pinentry-qt
      qbittorrent

      # CLI PROGRAMS ================================
      unzip
      ripgrep
      bat
      killall

      # languages and tools -------------------------
      # ...nix
      nh # Nix helper
      nixd # Nix language server
      alejandra
      # ...latex
      texliveFull
      # ...school
      octaveFull # GNU Octave (with gui)

      # FONTS AND OTHER =============================
      etBook
      cascadia-code
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
  modules.zotero.enable = false;
  modules.sway.enable = true;

  # global theme
  # themes can be previewed at https://tinted-theming.github.io/tinted-gallery/

  # dark themes
  modules.themes = {
    # themeName = "eris"; #                    dark blue city lights
    # themeName = "pico"; #                    highkey ugly but maybe redeemable
    # themeName = "tarot"; #                   very reddish purply
    # themeName = "kimber"; #                  nordish but more red
    # themeName = "embers"; #                  who dimmed the lights
    # themeName = "stella"; #                  purple, pale-ish
    # themeName = "zenburn"; #               ⋆ grey but in an endearing way
    # themeName = "onedark"; #                 atom propaganda
    # themeName = "darcula"; #               ⋆ jetbrains propaganda
    # themeName = "darkmoss"; #                cool blue-green
    # themeName = "gigavolt"; #                dark, vibrant, and purply
    themeName = "kanagawa"; #              ⋆ blue with yellowed text
    # themeName = "mountain"; #              ⋆ dark and moody
    # themeName = "darktooth"; #             ⋆ gruvbox but more purply
    # themeName = "everforest"; #              greenish and groovy
    # themeName = "summercamp"; #            ⋆ earthy but vibrant
    # themeName = "horizon-dark"; #            vaporwavey
    # themeName = "oxocarbon-dark"; #        ⋆ dark and vibrant
    # themeName = "terracotta-dark"; #       ⋆ chocolatey and dark
    # themeName = "tokyo-night-dark"; #        blue and purple
    # themeName = "gruvbox-dark-medium"; #   ⋆ a classic
    # themeName = "catppuccin-macchiato"; #    purple pastel

    # light themes
    # themeName = "earl-grey"; #               the coziest to ever do it
    # themeName = "ayu-light"; #               kinda pastel
    # themeName = "sagelight"; #               more pastel
    # themeName = "terracotta"; #              earthy and bright
    # themeName = "horizon-light"; #           vaporwavey
    # themeName = "classic-light"; #           basic and visible
    # themeName = "rose-pine-dawn"; #          cozy yellow and purple
    # themeName = "humanoid-light"; #          basic, visible, a lil yellowed
    # themeName = "solarized-light-v2"; #    ⋆ very much yellowed
  };

  # defaults (?)
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}

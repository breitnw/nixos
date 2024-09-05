{
  # inputs,
  # lib,
  # config,
  pkgs,
  ...
}:

{
  imports = [
    ./cli-programs
    ./gui-programs
    ./services
  ];

  nixpkgs = {
    # overlays = [];
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
      TERMINAL = "kitty";
      NIX_PATH = "~/NixOS";
    };

    packages = with pkgs; [
      #==============#
      # GUI PROGRAMS #
      #==============#

      firefox
      kitty
      sayonara # music player

      #==============#
      # CLI PROGRAMS #
      #==============#

      # random ----------------
      neofetch

      # dev tools -------------
      cmake
      rustup
      nil # Nix language server

      #===========#
      # LIBRARIES #
      #===========#

      libtool # required for vterm-module compilation

      #==========#
      # SERVICES #
      #==========#

      # TODO: configure gestures so they're actually useful
      # creates user daemon libinput-gestures.service
      # TODO: can this be enabled through config?
      libinput-gestures # touchpad gesture support
      wmctrl # allows libinput-gestures to interact with the window manager
    ];
  };

  xsession.enable = true;

  programs.home-manager.enable = true;
  programs.emacs.enable = true;
  programs.git.enable = true;
  programs.firefox.enable = true;
  programs.bat.enable = true;
  programs.fish.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}

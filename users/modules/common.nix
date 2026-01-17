{ config, ... }:

# MODULE ROOT AND UNIVERSAL CONFIGURATION

# TASKS
# - TODO configure vi keybinds globally and then apply them
#   to emacs, qutebrowser, vi, vim, etc.
# - TODO reload emacs theme as soon as config is regenerated (somehow)
# - TODO move sops spec to corresponding modules
# - TODO new design pattern for nix/doom interop: do everything in doom config;
#   only set variables in nix
# - TODO set MOZ_USE_XINPUT2=1, but maybe only on X11
# - TODO specializations for xorg and wayland

{
  imports = [
    ./programs
    ./services
    ./desktops
    ./themes
    ./secrets
    ./keybinds
  ];

  config = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    # enable home-manager (needs bootstrap)
    programs.home-manager.enable = true;

    # reload systemd units on home-manager switch 
    systemd.user.startServices = "sd-switch";

    # default applications
    xdg.mimeApps.enable = true;

    home.sessionVariables = {
      # config directory for nh
      NH_FLAKE = "${config.home.homeDirectory}/Config/nixos"; 
      # default graphical and TUI editor
      VISUAL = "${config.programs.emacs.package}/bin/emacsclient";
      EDITOR = "${config.programs.emacs.package}/bin.emacsclient -nw";
    };
  };
}

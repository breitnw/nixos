{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # ...
    ./programs/gui/kitty.nix
  ];

  nixpkgs = {
    # overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: add packages
  home = {
    username = "breitnw";
    homeDirectory = "/home/breitnw";
  };

  programs.home-manager.enable = true;
  programs.emacs.enable = true;
  programs.git.enable = true;
  programs.firefox.enable = true;
  programs.bat.enable = true;
  programs.fish.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}

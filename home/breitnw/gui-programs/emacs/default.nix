{ pkgs, config, ... }:

# based on https://github.com/sebnyberg/doomemacs-nix-example

{
  programs.emacs.enable = true;

  # from https://tech.j4m3s.eu/posts/emacs-nix-setup/
  home.sessionVariables = {
    DOOMDIR = "${config.xdg.configHome}/doom";
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
  };

  # add doom binaries to PATH
  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  xdg.configFile."emacs".source = pkgs.fetchFromGitHub {
    owner = "doomemacs";
    repo = "doomemacs";
    rev = "9c8cfaadde1ccc96a780d713d2a096f0440b9483";
    hash = "sha256-ketdYl75drmTQZRUvUDcVswUXGi0vKonzqopX8Maja8=";
  };

  xdg.configFile."doom".source = ./config/;
}

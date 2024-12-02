{ pkgs, config, ... }:

# might want to look at https://github.com/sebnyberg/doomemacs-nix-example
# for doom specific config

{
  config = {
    programs.emacs = {
      enable = true;
      package = pkgs.unstable.emacs30;
    };

    # set environment variables for doom
    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
    };

    # add doom binaries to PATH
    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    # fetch doom emacs
    xdg.configFile."emacs".source = builtins.fetchGit {
      url = "https://github.com/doomemacs/doomemacs.git";
      rev = "fca69c9849d3abcab0e8e1b1a17cf09298472715";
    };
  };
}

{ pkgs, config, ... }:

# might want to look at https://github.com/sebnyberg/doomemacs-nix-example
# for doom specific config

{
  config = {
    programs.emacs = {
      enable = true;
      package = pkgs.unstable.emacs30;
    };

    # add doom binaries to PATH
    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
  };
}

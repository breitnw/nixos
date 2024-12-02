{ pkgs, config, inputs, ... }:

# might want to look at https://github.com/sebnyberg/doomemacs-nix-example
# for doom specific config

{
  programs.doom-emacs = {
    enable = true;
    emacsPackage = pkgs.unstable.emacs30;
    doomPrivateDir = inputs.doom-config;

    # extraPackages = epkgs: [
    #   # tries to build native C code, so we include it here instead
    #   epkgs.vterm
    # ];
  };

  # add doom binaries to PATH
  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
}

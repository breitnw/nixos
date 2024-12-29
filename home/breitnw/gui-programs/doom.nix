{ config, lib, pkgs, ... }@args:

# might want to look at https://github.com/sebnyberg/doomemacs-nix-example
# for doom specific config

let
  cfg = config.modules.doom;
  # base16-doom provides the scheme itself
  base16-doom-repo = fetchGit {
    url = "https://github.com/MArpogaus/base16-doom.git";
    rev = "2618b791e738d04b89cd61ac76af75c5fd8d4cb1";
  };
  base16-doom = "${base16-doom-repo}/templates/default.mustache";
  mustache-base16 = import ../themes/mustache-base16.nix args;

in {
  options = {
    modules.doom = {
      theme = lib.mkOption {
        description = "The theme to use for doom";
        example = "doom-one";
        default = null;
        type = lib.types.nullOr lib.types.str;
      };
    };
  };
  config = {
    programs.emacs = {
      enable = true;
      # color stuff
      extraPackages = epkgs: [ epkgs.kurecolor ]; # required by the script
      extraConfig = if (isNull cfg.theme) then
        let
          themeDir = pkgs.writeTextFile {
            name = "doom-base16-theme.el";
            destination = "/doom-base16-theme.el";
            text = mustache-base16 (builtins.readFile base16-doom);
          };
        in ''
          (add-to-list 'custom-theme-load-path "${themeDir}")
          (setq doom-theme 'doom-base16)
        ''
      else
        "(setq doom-theme '${cfg.theme})";
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

    # FIXME fetch doom emacs
    # fetching sometimes has a bug (encountered when downgrading emacs version)
    # xdg.configFile."emacs".source = builtins.fetchGit {
    #   url = "https://github.com/doomemacs/doomemacs.git";
    #   rev = "fca69c9849d3abcab0e8e1b1a17cf09298472715";
    # };
  };
}

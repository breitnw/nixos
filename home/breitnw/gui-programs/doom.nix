{ config, lib, pkgs, ... }:

# might want to look at https://github.com/sebnyberg/doomemacs-nix-example
# for doom specific config

let
  cfg = config.modules.doom;
  # mustache is used for templating in the color scheme
  mustache-repo = fetchGit {
    url = "https://github.com/valodzka/nix-mustache.git";
    rev = "1155eeb0cbe33a448ceb3e9c4fb1583491ec79a5";
  };
  mustache = import "${mustache-repo}/mustache" { inherit lib; };
  # base16-doom provides the scheme itself
  base16-doom-repo = fetchGit {
    url = "https://github.com/MArpogaus/base16-doom.git";
    rev = "2618b791e738d04b89cd61ac76af75c5fd8d4cb1";
  };
  base16-doom = "${base16-doom-repo}/templates/default.mustache";

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
      extraPackages = epkgs:
        [
          epkgs.kurecolor # required by the script
        ];
      extraConfig = if (isNull cfg.theme) then
        let
          theme = mustache {
            template = builtins.readFile base16-doom;
            # TODO find a cleaner way to do this
            # maybe filter attrset by names and then map names if possible?
            view = with config.colorscheme.palette; {
              base00-hex = base00;
              base01-hex = base01;
              base02-hex = base02;
              base03-hex = base03;
              base04-hex = base04;
              base05-hex = base05;
              base06-hex = base06;
              base07-hex = base07;
              base08-hex = base08;
              base09-hex = base09;
              base0A-hex = base0A;
              base0B-hex = base0B;
              base0C-hex = base0C;
              base0D-hex = base0D;
              base0E-hex = base0E;
              base0F-hex = base0F;
            };
          };

          themeDir = pkgs.writeTextFile {
            name = "doom-base16-theme.el";
            destination = "/doom-base16-theme.el";
            text = theme;
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

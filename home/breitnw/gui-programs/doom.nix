{ config, lib, pkgs, ... }:

# might want to look at https://github.com/sebnyberg/doomemacs-nix-example
# for doom specific config

let
  cfg = config.modules.doom;
  # base16-doom provides the scheme itself
  base16-doom-repo = fetchGit {
    url = "https://github.com/breitnw/base16-doom.git";
    rev = "6b6df69dc176b39cb86734e500e989fedf9304f7";
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
    services.emacs = {
      # enable emacs daemon systemd service
      enable = true;
      # enable desktop item for emacs client
      client = { enable = true; };
      # client should be the default editor
      defaultEditor = true;
      # automatically start daemon when client is started
      socketActivation.enable = true;
    };
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk; # fixes artifacting issues
      extraPackages = epkgs: [
        epkgs.kurecolor # required by the color script
        epkgs.vterm
      ];
      # add packages to emacs's execution path
      extraConfig = ''
        (add-to-list 'exec-path "${pkgs.python3}/bin/")
        (add-to-list 'exec-path "${pkgs.ispell}/bin/")
        (add-to-list 'exec-path "${pkgs.fd}/bin/")
      ''
        # color stuff
        + (if (isNull cfg.theme) then
          let
            themeDir = pkgs.writeTextFile {
              name = "doom-base16-theme.el";
              destination = "/doom-base16-theme.el";
              text = config.utils.mustache.eval-base16
                (builtins.readFile base16-doom);
            };
          in ''
            (add-to-list 'custom-theme-load-path "${themeDir}")
            (setq doom-theme 'doom-base16)
          ''
        else
          "(setq doom-theme '${cfg.theme})");
    };

    # add doom binaries to PATH
    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
  };
}

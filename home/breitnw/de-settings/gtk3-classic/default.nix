# This file exposes options to graft gtk3-classic onto arbitrary applications,
# allowing the removal of unwanted client-side window decorations
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    modules.gtk3-classic = {
      grafts = lib.mkOption {
        description = ''
          A list of packages that should be grafted with gtk3-classic.

          Grafted packages will be exposed via a nixpkgs overlay, under the
          `grafted` attribute.
        '';
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            package = lib.mkOption {
              description = "The package to be grafted with gtk3-classic";
              type = lib.types.package;
            };
            custom-nixpkgs = lib.mkOption {
              description = ''
                The instance of nixpkgs to use when grafting. Useful if the package
                comes from a flake.
              '';
              # I don't think we can be more specific here, since evaluating all
              # of nixpkgs to typecheck would be bad
              type = with lib.types; nullOr attrs;
              default = null;
            };
          };
        });
      };
    };
  };

  config = {
    # Graft GTK3-classic onto GTK3 applications
    # https://discourse.nixos.org/t/any-way-to-patch-gtk3-systemwide/59737/2
    nixpkgs.overlays = [
      (self: super: {
        grafted =
          builtins.mapAttrs (
            name: value: let
              graft-pkgs =
                if isNull value.custom-nixpkgs
                then pkgs
                else value.custom-nixpkgs;
              graft = import ./graft.nix graft-pkgs;
            in
              graft value.package
          )
          config.modules.gtk3-classic.grafts;
      })
    ];

    # To disable the close button:
    # https://gist.github.com/lukateras/aa4da74f4b93101d2ed3444aba3a1b5f
    # gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:none
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {button-layout = "appmenu:none";};
    };
  };
}

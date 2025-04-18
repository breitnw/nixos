{ pkgs, ... }:

# settings for the desktop environment, window manager,
# compositor... y'know, the works.

{
  imports = [ ./xfconf ./picom.nix ];

  config = {
    # Graft GTK3-classic onto GTK3 applications
    # https://discourse.nixos.org/t/any-way-to-patch-gtk3-systemwide/59737/2
    nixpkgs.overlays = let
      graft = import ./gtk3-classic.nix {
        pkgs = pkgs;
        lib = pkgs.lib;
      };
    in [ (self: super: { zotero-nix-grafted = (graft pkgs.zotero-nix); }) ];

    # To disable the close button:
    # https://gist.github.com/lukateras/aa4da74f4b93101d2ed3444aba3a1b5f
    # gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:none
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = { button-layout = "appmenu:none"; };
    };
  };
}

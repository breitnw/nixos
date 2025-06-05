{
  pkgs,
  inputs,
  ...
}:
# settings for the desktop environment, window manager,
# compositor... y'know, the works.
{
  imports = [./xfconf ./picom.nix];

  config = {
    # TODO should this be in a different file?

    # Graft GTK3-classic onto GTK3 applications
    # https://discourse.nixos.org/t/any-way-to-patch-gtk3-systemwide/59737/2
    nixpkgs.overlays = let
      zotero-nix-pkgs = import inputs.zotero-nix.inputs.nixpkgs {inherit (pkgs) system;};
      graft = import ./gtk3-classic.nix zotero-nix-pkgs;
    in [(self: super: {zotero-nix-grafted = graft pkgs.zotero-nix;})];

    # To disable the close button:
    # https://gist.github.com/lukateras/aa4da74f4b93101d2ed3444aba3a1b5f
    # gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:none
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {button-layout = "appmenu:none";};
    };
  };
}

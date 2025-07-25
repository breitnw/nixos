{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  options = {
    modules.zotero = {
      enable = lib.mkEnableOption "Whether to enable Zotero";
    };
  };

  config = lib.mkIf config.modules.zotero.enable {
    home.packages = [
      pkgs.grafted.zotero-nix
    ];
    modules.gtk3-classic.grafts = {
      zotero-nix = {
        package = pkgs.zotero-nix;
        custom-nixpkgs =
          import inputs.zotero-nix.inputs.nixpkgs
          {inherit (pkgs) system;};
      };
    };
  };
}

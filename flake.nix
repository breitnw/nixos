{
  description = "breitnw's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nix-colors.url = "github:misterio77/nix-colors";
    firefox-native-base16.url = "github:GnRlLeclerc/firefox-native-base16";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "aarch64-linux";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in {
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      nixosConfigurations = {
        mnd = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            # enable an overlay with unstable packages
            # ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/mnd/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "breitnw@mnd" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs; };
          modules = [
            # enable an overlay with unstable packages
            ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./home/breitnw/home.nix
          ];
        };
      };
    };
}

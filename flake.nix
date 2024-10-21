{
  description = "breitnw's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    # inherit (self) outputs;
    system = "aarch64-linux";
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };
  in {
    formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

    nixosConfigurations = {
      mnd = nixpkgs-unstable.lib.nixosSystem {
        # specialArgs = { inherit system; };
        modules = [
          # hardware-configuration.nix is imported by configuration.nix
          ./hosts/mnd/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "breitnw@mnd" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        # extraSpecialArgs = { inherit system; };
        modules = [
          # enable an overlay with unstable packages
          ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./home-manager/home.nix
        ];
      };
    };
  };
}

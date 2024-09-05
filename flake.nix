{
  description = "breitnw's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # inherit (self) outputs;
    system = "aarch64-linux";
  in {
    formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

    nixosConfigurations = {
      nix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          # hardware-configuration.nix is imported by configuration.nix
          ./hosts/nix/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "breitnw@nix" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs system; };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}

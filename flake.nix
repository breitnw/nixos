{
  description = "breitnw's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "aarch64-linux";
  in {
    formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

    nixosConfigurations = {
      nix = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          # hardware-configuration.nix is imported by configuration.nix
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "breitnw@nix" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}

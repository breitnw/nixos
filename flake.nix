{
  description = "breitnw's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon/main";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    apple-silicon-support,
    ...
  } @ inputs: let
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
          # hardware-configuration.nix is imported by configuration.nix
          ./hosts/mnd/configuration.nix
          apple-silicon-support.modules.nixos.default
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

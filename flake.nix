{
  description = "breitnw's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # search for files (e.g., headers) in nixpkgs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # apple silicon support modules
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    # system-wide theming
    nix-colors.url = "github:misterio77/nix-colors";
    # theming for firefox
    firefox-native-base16.url = "github:GnRlLeclerc/firefox-native-base16";
    # zotero built from source
    zotero-nix.url = "github:camillemndn/zotero-nix";
    # cozette built from source
    cozette.url = "github:breitnw/cozette/dev";
    # greybird with custom accent support
    greybird.url = "github:breitnw/Greybird/master";
    # tiny-dfr built from source
    tiny-dfr.url = "github:WhatAmISupposedToPutHere/tiny-dfr/master";
    # tiny-dfr.url = "path:./flakes/tiny-dfr";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-index-database,
    apple-silicon-support,
    cozette,
    greybird,
    tiny-dfr,
    ...
  } @ inputs: let
    system = "aarch64-linux";
    # overlay for unstable and unfree packages, under the "unstable" attribute
    overlay-unstable = final: prev: {
      # instantiate nixpkgs-unstable to allow unfree packages
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    # overlay for extra packages fetched from flakes
    overlay-extra = final: prev:
      with inputs; {
        firefox-native-base16 =
          firefox-native-base16.packages.${prev.system}.default;
        zotero-nix = zotero-nix.packages.${prev.system}.default;
        cozette = cozette.packages.${prev.system}.default;
        greybird-with-accent =
          greybird.packages.${prev.system}.greybird-with-accent;
        tiny-dfr = tiny-dfr.packages.${prev.system}.default;
        zen-browser = zen-browser.packages.${prev.system}.default;
      };
  in {
    formatter = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations = {
      mnd = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ({...}: {nixpkgs.overlays = [overlay-extra];})
          # enable an overlay with unstable packages
          # ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./hosts/mnd/configuration.nix
          nix-index-database.nixosModules.nix-index
          apple-silicon-support.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      "breitnw@mnd" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs;};
        modules = [
          # enable an overlay with unstable packages
          ({...}: {
            nixpkgs.overlays = [overlay-unstable overlay-extra];
          })
          ./home/breitnw/home.nix
        ];
      };
    };
  };
}

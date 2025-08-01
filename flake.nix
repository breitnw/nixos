{
  description = "breitnw's nixos config";

  inputs = {
    # CORE (packages, system, etc) =============================================

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # apple silicon support modules
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # lix, since it seems to have better logging & performance
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # PROGRAMS AND UTILS =======================================================

    # secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    # search for files (e.g., headers) in nixpkgs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # tiny-dfr built from source
    tiny-dfr.url = "github:WhatAmISupposedToPutHere/tiny-dfr/master";
    # zotero built from source
    zotero-nix.url = "github:camillemndn/zotero-nix";

    # THEMING ==================================================================

    # system-wide theming
    nix-colors.url = "github:misterio77/nix-colors"; # palettes
    nix-rice.url = "github:bertof/nix-rice"; # utils
    # theming for firefox
    firefox-native-base16.url = "github:GnRlLeclerc/firefox-native-base16";
    # cozette built from source
    cozette.url = "github:breitnw/cozette/dev";
    # greybird with custom accent support
    greybird.url = "github:breitnw/Greybird/master";

    # NON-FLAKE ================================================================
    # I prefer flake inputs over fetchGit, since fetchGit hits the network every
    # time `home-manager switch` gets run
    # maybe related: https://github.com/NixOS/nix/issues/10773

    nix-mustache = {
      url = "github:valodzka/nix-mustache";
      flake = false;
    };
    base16-qutebrowser = {
      url = "github:tinted-theming/base16-qutebrowser";
      flake = false;
    };
    base16-doom = {
      url = "github:breitnw/base16-doom";
      flake = false;
    };
    base16-alacritty = {
      url = "github:aarowill/base16-alacritty";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-index-database,
    apple-silicon-support,
    lix,
    cozette,
    greybird,
    # tiny-dfr,
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
          lix.nixosModules.default
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

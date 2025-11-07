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
    cozette.url = "github:breitnw/cozette/dev-updated";
    # cozette with modifications for use of glyphs with terminus
    bitmap-glyphs-12.url = "github:breitnw/bitmap-glyphs-12";
    bitmap-glyphs-12.inputs.cozette.follows = "cozette";
    # greybird with custom accent support
    greybird.url = "github:breitnw/Greybird/master";
    # temporarily convert symlinks to real files⦂arstei
    hm-ricing-mode.url = "github:mipmip/hm-ricing-mode";
    # flakified icon theme
    buuf-icon-theme.url = "github:breitnw/buuf-gnome";

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
    bitmap-glyphs-12,
    greybird,
    hm-ricing-mode,
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
        bitmap-glyphs-12 = bitmap-glyphs-12.packages.${prev.system}.default;
        greybird-with-accent =
          greybird.packages.${prev.system}.greybird-with-accent;
        tiny-dfr = tiny-dfr.packages.${prev.system}.default;
        # virglrenderer = prev.virglrenderer.overrideAttrs (old: {
        #   src = final.fetchurl {
        #     url = "https://gitlab.freedesktop.org/asahi/virglrenderer/-/archive/asahi-20250424/virglrenderer-asahi-20250424.tar.bz2";
        #     hash = "sha256-9qFOsSv8o6h9nJXtMKksEaFlDP1of/LXsg3LCRL79JM=";
        #   };
        #   mesonFlags = old.mesonFlags ++ [ (final.lib.mesonOption "drm-renderers" "asahi-experimental") ];
        # });
      };
  in {
    formatter = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations = {
      mnd = nixpkgs-unstable.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ({...}: {nixpkgs.overlays = [overlay-unstable overlay-extra];})
          # enable an overlay with unstable packages
          # ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./hosts/mnd/configuration.nix
          nix-index-database.nixosModules.nix-index
          apple-silicon-support.nixosModules.default
          # lix.nixosModules.default
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
          hm-ricing-mode.homeManagerModules.hm-ricing-mode
        ];
      };
    };
  };
}

{
  description = "breitnw's nixos config";

  inputs = {
    # CORE (packages, system, etc) =============================================

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # apple silicon support modules
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
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
    tiny-dfr.url = "github:AsahiLinux/tiny-dfr";
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
    # temporarily convert symlinks to real files
    hm-ricing-mode.url = "github:Markus328/hm-ricing-mode/fix-hm-module";
    # flakified icon theme
    buuf-icon-theme.url = "github:breitnw/buuf-gnome";
    # niri window manager
    niri-flake.url = "github:sodiboo/niri-flake";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    # cursor theme
    hackneyed.url = "github:owm111/hackneyed-x11-cursors";

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

  outputs = inputs: let
    # overlay for unstable packages, under the "unstable" attribute
    overlay-unstable = final: prev:
      let
        prev-system = prev.stdenv.hostPlatform.system;
      in {
        # instantiate nixpkgs-unstable to allow unfree packages
        unstable = import inputs.nixpkgs-unstable {
          system = prev-system;
          config.allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };

    # overlay for extra packages fetched from flakes
    overlay-extra = final: prev:
      with inputs; let
        system = prev.stdenv.hostPlatform.system;
        defaultPackage = inp: inp.packages.${system}.default;
      in {
        firefox-native-base16 = defaultPackage firefox-native-base16;
        zotero-nix = defaultPackage zotero-nix;
        cozette = defaultPackage cozette;
        bitmap-glyphs-12 = defaultPackage bitmap-glyphs-12;
        tiny-dfr = defaultPackage tiny-dfr;
        greybird-with-accent = greybird.packages.${system}.greybird-with-accent;
      };

    # configuration for each system NixOS/Home Manager will be deployed to
    systems = {
      core = {
        sysinfo = ./systems/core/system.nix;
        hardware-config = ./systems/core/hardware-configuration.nix;
        host-config = ./hosts/core.nix;
        user-config = ./users/breitnw-at-core.nix;
      };
      lite = {
        sysinfo = ./systems/lite/system.nix;
        hardware-config = ./systems/lite/hardware-configuration.nix;
        host-config = ./hosts/lite.nix;
        user-config = ./users/breitnw-at-lite.nix;
      };
    };
  in {
    # generate NixOS configurations for each system
    nixosConfigurations = builtins.mapAttrs (name: cfg: 
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ({...}: {
            nixpkgs.overlays = [
              overlay-unstable
              overlay-extra
            ];
          })

          # host configuration modules
          ./hosts/modules/common.nix
          # host configuration
          cfg.host-config
          # system options module
          ./systems/options.nix
          # system configuration
          cfg.sysinfo
          # hardware configuration
          cfg.hardware-config

          # Other dependencies
          inputs.nix-index-database.nixosModules.nix-index
          inputs.apple-silicon-support.nixosModules.default # only enabled on asahi
        ];
      }) systems;

    # generate home-manager configurations for each system
    homeConfigurations = inputs.nixpkgs.lib.mapAttrs' (system-name: cfg: {
      name = "breitnw@${system-name}";
      value = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages
          .${(import cfg.sysinfo).sysinfo.system};
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ({...}: {
            nixpkgs.overlays = [
              overlay-unstable
              overlay-extra
              inputs.hackneyed.overlay
            ];
          })

          # home-manager configuration modules
          ./users/modules/common.nix
          # home-manager configuration
          cfg.user-config
          # system options module
          ./systems/options.nix
          # system configuration
          cfg.sysinfo

          # Other dependencies
          inputs.niri-flake.homeModules.niri
          inputs.hm-ricing-mode.homeManagerModules.hm-ricing-mode
        ];
      };
    }) systems;
  };
}

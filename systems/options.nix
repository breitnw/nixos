{ lib, ... }:

{
  options = {
    sysinfo = {
      system = lib.mkOption {
        type = lib.types.enum [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };
      asahi = lib.mkEnableOption
        "Whether to enable Asahi Linux support modules";
      available-features = {
        vsync = lib.mkEnableOption
          "Whether vertical synchronization in X.Org is supported";
        gamma-ramp = lib.mkEnableOption
          "Whether gamma shifting is supported (e.g., redshift, gammastep)";
        dp-alt-mode = lib.mkEnableOption ''
          Whether DisplayPort Alt Mode is supported. If it is not, the system
          configuration should enable DisplayLink.
        '';
      };
      keyboard-management = let
        mkKeySeqOption = description: lib.mkOption {
          inherit description;
          # more specific types can be found in hosts/modules/input/evremap.nix
          type = lib.types.listOf lib.types.str;
        };
      in {
        internal-kbd-name = lib.mkOption {
          type = lib.types.str;
        };
        internal-kbd-remap = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule {
            options = {
              input = mkKeySeqOption "The key sequence that should be remapped.";
              output = mkKeySeqOption "The key sequence that should be output when the input sequence is entered.";
            };
          });
          default = [];
        };
      };
      display-management = {
        displays = lib.mkOption {
          description = "The displays available for this system";
          type = lib.types.attrsOf (lib.types.submodule {
            options = {
              fingerprint = lib.mkOption {
                type = lib.types.str;
                description = "the fingerprint of this display (see autorandr --fingerprint)";
                example = "00ffffffffffff0006af991900000000341e0104951f117802c0d58f5658932920505400000001010101010101010101010101010101ce1d56e250001e302616360035ad10000018df1356e250001e302616360035ad1000001800000000000000000000000000000000000000000002001048ff0f3c7d1f1222c4202020008e";
              };
              pixel-size.width = lib.mkOption {
                type = lib.types.int;
                description = "the width of this display in physical (not logical) pixels";
              };
              pixel-size.height = lib.mkOption {
                type = lib.types.int;
                description = "the height of this display in physical (not logical) pixels";
              };
              scale.xorg = lib.mkOption {
                type = lib.types.float;
                description = "the scale of this display on x.org systems";
              };
              scale.wayland = lib.mkOption {
                type = lib.types.float;
                description = "the scale of this display on wayland systems";
              };
            };
          });
        };
        profiles = lib.mkOption {
          description = "The display profiles available for this system (e.g., for autorandr)";
          type = lib.types.attrsOf (lib.types.attrsOf (lib.types.submodule {
            options = {
              position = lib.mkOption {
                description = "the position of this display in logical pixels";
                example = "1366x0";
              };
              primary = lib.mkEnableOption "whether this is the primary display in the profile";
            };
          }));
        };
      };
    };
  };
}

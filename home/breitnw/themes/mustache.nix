{
  inputs,
  config,
  lib,
  ...
}: let
  # mustache is used for templating in the color scheme
  cfg = config.utils.mustache;
in {
  options = {
    utils.mustache = {
      eval = lib.mkOption {
        description = "the mustache function from nix-mustache";
      };
      eval-base16 = lib.mkOption {
        description = "a function to fill a mustache template based on the nix-colors palette";
      };
    };
  };

  config = {
    utils.mustache = {
      eval = import "${inputs.nix-mustache}/mustache" {inherit lib;};
      eval-base16 = template:
        cfg.eval {
          inherit template;
          view =
            lib.attrsets.mapAttrs' (name: value: {
              name = "${name}-hex";
              value = value;
            })
            config.colorScheme.palette;
        };
    };
  };
}

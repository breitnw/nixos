{ config, lib, ... }:

let
  # mustache is used for templating in the color scheme
  mustache-repo = fetchGit {
    url = "https://github.com/valodzka/nix-mustache.git";
    rev = "1155eeb0cbe33a448ceb3e9c4fb1583491ec79a5";
  };
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
      eval = import "${mustache-repo}/mustache" { inherit lib; };
      eval-base16 = template: cfg.eval {
        inherit template;
        view = (lib.attrsets.mapAttrs' (name: value: {
          name = "${name}-hex";
          value = value;
        }) config.colorScheme.palette);
      };
    };
  };
}

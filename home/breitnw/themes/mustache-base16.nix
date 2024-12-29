{ config, lib, ... }:

let
  # mustache is used for templating in the color scheme
  mustache-repo = fetchGit {
    url = "https://github.com/valodzka/nix-mustache.git";
    rev = "1155eeb0cbe33a448ceb3e9c4fb1583491ec79a5";
  };
  mustache = import "${mustache-repo}/mustache" { inherit lib; };

in template:
mustache {
  inherit template;
  view = (lib.attrsets.mapAttrs' (name: value: {
    name = "${name}-hex";
    value = value;
  }) config.colorScheme.palette);
}

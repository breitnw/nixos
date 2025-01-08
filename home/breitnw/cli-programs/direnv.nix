{ ... }:

{
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      # fish integration is automatically enabled
      nix-direnv.enable = true;
    };

    bash.enable = true; # so that home-manager can manage bash
    fish.enable = true; # ... etc
  };
}

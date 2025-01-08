# secrets management via sops-nix

{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./keys.nix
  ];

  config = {
    home.packages = [
      pkgs.sops
    ];

    sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/breitnw/.config/sops/age/keys.txt";
  };
}

{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./keys.nix
  ];

  config = {
    environment.systemPackages = [
      pkgs.sops
    ];

    sops.defaultSopsFile = ../../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/breitnw/.config/sops/age/keys.txt";
  };
}

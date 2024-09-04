{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.aarch64-linux.hello = nixpkgs.legacyPackages.aarch64-linux.hello;

    packages.aarch64-linux.default = self.packages.aarch64-linux.hello;

  };
}

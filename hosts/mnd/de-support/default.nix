{ lib, ... }:

# Desktop environment support modules

{
  options = {
    desktops = {
      default = lib.mkOption {
        default = "xfce";
        type = lib.types.enum [
          "xfce"
          "kde"
        ];
      };
    };
  };

  imports = [
    ./xfce.nix
    ./kde.nix

  ];
}

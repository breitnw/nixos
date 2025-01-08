{ pkgs, ... }:

{
  # enable pass
  programs.password-store.enable = true;
  # gpg is used to generate keys for pass
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
  # gui for viewing passwords
  home.packages = [
    pkgs.qtpass
  ];
}

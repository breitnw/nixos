{pkgs, config, ...}: {
  # enable pass
  programs.password-store.enable = true;
  programs.password-store.settings = {
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
  };
  # gpg is used to generate keys for pass
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
  };
  # gui for viewing passwords
  home.packages = [pkgs.qtpass];
}

pkgs:

{
  home.packages = [
    pkgs.gruvbox-dark-gtk
  ];

  # XFCE
  xfconf.settings.xsettings = {
    "Net/ThemeName" = "gruvbox-dark";
  };

  # kitty
  programs.kitty.theme = "Gruvbox Dark";

  # TODO: emacs theme?

  # firefox
  # programs.firefox = {
  #   profiles."breitnw" = {
  #     extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #       gruvbox-theme
  #     ];
  #   };
  # };
}

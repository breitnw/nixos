pkgs:

{
  home.packages = [];

  # XFCE
  xfconf.settings.xsettings = {
    "Net/ThemeName" = "Adwaita-dark";
  };

  # kitty
  programs.kitty.theme = "Brogrammer";

  # TODO: emacs theme?

  # firefox
}

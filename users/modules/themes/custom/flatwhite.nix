# Theme inspired by Doom Emacs' doom-flatwhite
{...}: {
  colorScheme = {
    name = "Flatwhite";
    slug = "flatwhite";
    author = "JuneKelly (adapted by breitnw)";
    variant = "light";
    palette = {
      base00 = "#f1ece4"; # ----
      base01 = "#e4ddd2"; # ---
      base02 = "#dcd3c6"; # --
      base03 = "#b9a992"; # -
      base04 = "#93836c"; # +
      base05 = "#605a52"; # ++
      base06 = "#202328"; # +++
      base07 = "#1c1f24"; # ++++
      base08 = "#957f5f"; # orange
      base09 = "#957f5f"; # yellow
      base0A = "#81895d"; # green
      base0B = "#5f8c7d"; # turquois
      base0C = "#7382a0"; # aqua
      base0D = "#9c739c"; # purple
      base0E = "#9c739c"; # pink
      base0F = "#955f5f"; # red
    };
  };
  modules.doom.theme = "doom-flatwhite";
  # TODO this doesn't work
  programs.emacs.extraConfig = "(setq global-hl-line-mode nil)";
}

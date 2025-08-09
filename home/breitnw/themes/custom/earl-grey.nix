# Theme inspired by Doom Emacs' doom-earl-grey
{...}: {
  colorScheme = {
    name = "Earl Grey";
    slug = "earl-grey";
    author = "JuneKelly (adapted by breitnw)";
    variant = "light";
    palette = {
      base00 = "#FCFBF9"; # ----
      base01 = "#F7F3EE"; # ---
      base02 = "#eae6e2"; # --
      base03 = "#DDDBD8"; # -
      base04 = "#9E9A95"; # +
      base05 = "#7F7A73"; # ++
      base06 = "#605A52"; # +++
      base07 = "#4C4741"; # ++++
      base08 = "#886A44"; # orange
      base09 = "#886A44"; # yellow
      base0A = "#747B4D"; # green
      base0B = "#477A7B"; # turquois
      base0C = "#556995"; # aqua
      base0D = "#82576D"; # purple
      base0E = "#AA5087"; # pink
      base0F = "#8F5652"; # red
    };
  };

  modules.doom.theme = "doom-earl-grey";
}

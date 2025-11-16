{lib, ...}: {
  colorScheme = {
    name = "Elemental";
    slug = "elemental";
    author = "FredHappyface (https://github.com/fredHappyface)";
    variant = "dark";
    palette = {
      base00 = "#21211c";
      base01 = "#3c3b30";
      base02 = "#545444";
      base03 = "#5f5d50";
      base04 = "#6a665c";
      base05 = "#756f68";
      base06 = "#807974";
      base07 = "#fff1e8";
      base08 = "#97280f";
      base09 = "#7f7110";
      base0A = "#78d8d8";
      base0B = "#479942";
      base0C = "#387f58";
      base0D = "#497f7d";
      base0E = "#7e4e2e";
      base0F = "#4b1407";
    };
  };
  modules.fastfetch.image = ../../programs/fastfetch/images/9.jpg;
  # modules.de.xfconf.panelBackgroundColor = [ 0.0 0.0 0.0 0.0 ];
  # modules.de.xfconf.panelOpacity = 75;
}

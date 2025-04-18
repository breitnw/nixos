{ pkgs, lib, ... }:
let
  # This is a straight copy from upstream (which deprecated this function), as
  # I don't see another way of doing this
  readPathsFromFile = (rootPath: file:
    let
      lines = lib.splitString "\n" (builtins.readFile file);
      removeComments =
        lib.filter (line: line != "" && !(lib.hasPrefix "#" line));
      relativePaths = removeComments lines;
      absolutePaths = map (path: rootPath + "/${path}") relativePaths;
    in absolutePaths);

  # GTK3-classic
  gtk3-classic = pkgs.gtk3.overrideAttrs (old: {
    patches = old.patches ++ (let
      classic = pkgs.fetchFromGitHub {
        owner = "lah7";
        repo = "gtk3-classic";
        rev = old.version;
        sha256 = "sha256-85F8iLyWdBKMfyXYpyHXFYlvptCEQ6FDQ9YXnKSlgKU=";
      };
      quiltSeries = name: src:
        readPathsFromFile (builtins.path {
          path = src;
          name = (name + "-patches");
          filter =
            (path: type: (type == "regular") && (lib.hasSuffix ".patch" path));
        }) (src + "/series");
    in (quiltSeries "gtk3-classic" classic));
  });
in pkg:
let
  graft = (p:
    pkgs.replaceDependency {
      drv = p;
      oldDependency = pkgs.gtk3;
      newDependency = gtk3-classic;
    });
  # Add override methods to make graft/replaceDependency act more like a
  # package derivation
in ((graft pkg) // {
  override = (o: graft (pkg.override o));
  overrideDerivation = (od: graft (pkg.overrideDerivation od));
})

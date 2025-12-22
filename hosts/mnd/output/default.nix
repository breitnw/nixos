{...}: {
  imports = [./displaylink.nix ./audio.nix];

  config = {
    modules.output.displaylink.enable = true;
  };
}

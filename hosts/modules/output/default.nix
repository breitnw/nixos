{config, ...}: {
  imports = [./displaylink.nix ./audio.nix];

  config = {
    # enable displaylink if DP altmode is not supported
    modules.output.displaylink.enable = !config.platform.available-features.dp-alt-mode;
  };
}

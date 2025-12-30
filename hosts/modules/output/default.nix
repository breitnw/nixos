{config, ...}: {
  imports = [./displaylink.nix ./audio.nix];

  config = {
    # enable displaylink if DP altmode is not supported
    modules.output.displaylink.enable = !config.sysinfo.available-features.dp-alt-mode;
  };
}

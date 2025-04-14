{ pkgs, ... }:

# Most of the audio stuff is handled by the apple silicon support module,
# so this file just contains some odds and ends.
# Pipewire is enabled in apple-silicon-support/modules/sound/default.nix

{
  environment.systemPackages = with pkgs; [
    pavucontrol # a volume mixer
    qjackctl # GUI for jackd
  ];

  services.pipewire.jack.enable = true;
}

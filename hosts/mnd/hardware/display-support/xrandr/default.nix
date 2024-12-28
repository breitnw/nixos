{ ... }:

{
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     xorg.xrandr = prev.xorg.xrandr.overrideAttrs {
  #       # always use nearest filtering when the display is scaled. The
  #       # default (bilinear) is ugly
  #       patches = [ ./nearest.patch ];
  #     };
  #   })
  # ];
}

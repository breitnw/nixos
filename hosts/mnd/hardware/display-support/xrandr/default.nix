{ pkgs, ... }:

{
  # patch xrandr to always use nearest filtering when the display
  # is scaled. The default (bilinear) is all smudgy
  nixpkgs.overlays = [
    (final: prev: {
      xorg = prev.xorg.overrideScope (xfinal: xprev: {
        xrandr-patched = xprev.xrandr.overrideAttrs (old: {
          patches = (old.patches or []) ++ [ ./nearest.patch ];
        });
      });
    })
  ];

  # apply scaling to eDP-1, the internal display, so that text is bigger
  # without adjusting DPI
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr-patched}/bin/xrandr --output eDP-1 --scale "0.5x0.5"
  '';
}

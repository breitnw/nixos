{ pkgs, ... }:

# codec dependencies for parole

{
  home.packages = [ pkgs.xfce.parole ];
  nixpkgs.overlays = [
    (final: prev: {
      xfce = prev.xfce.overrideScope (xfinal: xprev: {
        parole = xprev.parole.overrideAttrs (old: {
          buildInputs = with pkgs;
            old.buildInputs ++ [
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-libav
            ];
        });
      });
    })
  ];
}

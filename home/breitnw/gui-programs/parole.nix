{ pkgs, ... }:

# codec dependencies for parole
# TODO i don't think this works for some reason

{
  home.packages = with pkgs; [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];
}

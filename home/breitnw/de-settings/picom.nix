{ ... }:

# for my compositor, I use picom, which is a fork of compton.
# I don't know if it can solve the vsync issues (some posts
# have said it can), but it looks pretty regardless.

# TODO does this mean I need to somehow turn off the default
# xfwm4 compositor in my config?

{
  services.picom = {
    enable = true;
    vSync = true;
    fade = true;
    shadow = true;
    fadeDelta = 3;
    backend = "glx";
  };
}

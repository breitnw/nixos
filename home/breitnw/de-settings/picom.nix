{ ... }:

# for my compositor, I use picom, which is a fork of compton.
# I don't know if it can solve the vsync issues (some posts
# have said it can), but it looks pretty regardless.

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

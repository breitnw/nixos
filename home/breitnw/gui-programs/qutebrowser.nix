{ config, pkgs, lib, ... }:

let
  # base16-qutebrowser provides the scheme
  base16-qutebrowser-repo = fetchGit {
    url = "https://github.com/tinted-theming/base16-qutebrowser.git";
    rev = "f93ee127436820c2f109a1eaa5a463cd7101da9e";
  };
  base16-qutebrowser = "${base16-qutebrowser-repo}/templates/default.mustache";

in {
  programs.qutebrowser = {
    enable = true;
    # I'm using unstable for now because the stable version has a rendering bug
    # where some bitmap fonts (including creep) aren't rendered
    package = pkgs.unstable.qutebrowser;
    settings = {
      fonts = with config.modules.de.xfce; {
        default_family = defaultFont.family;
        prompts = "default_size default_family";
      };
      # TODO make helper to create python dict from attrset
      tabs = {
        "padding[\"bottom\"]" = 4;
        "padding[\"top\"]" = 4;
        position = "left";
      };
      statusbar = {
        "padding[\"bottom\"]" = 4;
        "padding[\"top\"]" = 4;
      };
      content.javascript.clipboard = "access";
      zoom.default = "90%";
      scrolling.bar = "when-searching";
      hints.chars = "arstneiodh"; # colemak!
    };
    keyBindings = with config.utils.keybinds; {
      # see :help bindings.default
      caret = {
        "${vi.left}" = "move-to-prev-char";
        "${vi.down}" = "move-to-next-line";
        "${vi.up}" = "move-to-prev-line";
        "${vi.right}" = "move-to-next-char";
        # FIXME don't think these work
        # "${vi.word-back}" = "move-to-prev-word";
        # "${vi.word-end}" = "move-to-end-of-word";
        # "${vi.word-next}" = "move-to-next-word";
      };
      normal = {
        "${vi.left}" = "scroll left";
        "${vi.down}" = "scroll down";
        "${vi.up}" = "scroll up";
        "${vi.right}" = "scroll right";
        "${lib.toUpper vi.left}" = "back";
        "${lib.toUpper vi.down}" = "tab-next";
        "${lib.toUpper vi.up}" = "tab-prev";
        "${lib.toUpper vi.right}" = "forward";
        "${vi.jump-inclusive}" = "hint";
        "${vi.insert-before}" = "mode-enter insert";
        "${vi.insert-after}" = "mode-enter insert";
        "${vi.undo}" = "undo";
        "${vi.search-next}" = "search-next";
        "${lib.toUpper vi.search-next}" = "search-prev";
      } // (let
        spawn = ''
          spawn --userscript qute-pass --username-target secret --username-pattern "login: (.+)"'';
      in {
        "zl" = "${spawn}";
        "zul" = "${spawn} --username-only";
        "zpl" = "${spawn} --password-only";
      });
    };
    extraConfig = let
      themeFile = pkgs.writeTextFile {
        name = "theme.py";
        text = config.utils.mustache.eval-base16
          (builtins.readFile base16-qutebrowser);
      };
    in ''
      config.source("${themeFile}")
      # load the selected tab foreground after the theme
      c.colors.tabs.selected.even.fg = "#${config.colorscheme.palette.base0E}";
      c.colors.tabs.selected.odd.fg = "#${config.colorscheme.palette.base0E}";
    '';
  };
}

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
    keyBindings = {
      # see :help bindings.default
      caret = {
        "${config.keybinds.vi.left}" = "move-to-prev-char";
        "${config.keybinds.vi.down}" = "move-to-next-line";
        "${config.keybinds.vi.up}" = "move-to-prev-line";
        "${config.keybinds.vi.right}" = "move-to-next-char";
        # FIXME don't think these work
        # "${config.keybinds.vi.word-back}" = "move-to-prev-word";
        # "${config.keybinds.vi.word-end}" = "move-to-end-of-word";
        # "${config.keybinds.vi.word-next}" = "move-to-next-word";
      };
      normal = {
        "${config.keybinds.vi.left}" = "scroll left";
        "${config.keybinds.vi.down}" = "scroll down";
        "${config.keybinds.vi.up}" = "scroll up";
        "${config.keybinds.vi.right}" = "scroll right";
        "${lib.toUpper config.keybinds.vi.left}" = "back";
        "${lib.toUpper config.keybinds.vi.down}" = "tab-next";
        "${lib.toUpper config.keybinds.vi.up}" = "tab-prev";
        "${lib.toUpper config.keybinds.vi.right}" = "forward";
        "${config.keybinds.vi.jump-inclusive}" = "hint";
        "${config.keybinds.vi.insert-before}" = "mode-enter insert";
        "${config.keybinds.vi.insert-after}" = "mode-enter insert";
        "${config.keybinds.vi.undo}" = "undo";
        "${config.keybinds.vi.search-next}" = "search-next";
        "${lib.toUpper config.keybinds.vi.search-next}" = "search-prev";
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

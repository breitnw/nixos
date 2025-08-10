{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    modules.qutebrowser = {
      enable = lib.mkEnableOption "whether or not to enable qutebrowser";
    };
  };
  config = let
    # base16-qutebrowser provides the scheme
    base16-qutebrowser = "${inputs.base16-qutebrowser}/templates/default.mustache";
  in
    lib.mkIf config.modules.qutebrowser.enable {
      programs.qutebrowser = {
        enable = true;
        # I'm using unstable for now because the stable version has a rendering bug
        # where some bitmap fonts (including creep) aren't rendered
        package = pkgs.qutebrowser;
        settings = let
          describeFont = font: "${toString font.size}px ${font.family}";
        in {
          fonts = {
            default_family = config.utils.fonts.primary.family;
            prompts = "default_size default_family";
            tabs.selected = describeFont config.utils.fonts.secondary;
            tabs.unselected = describeFont config.utils.fonts.secondary;
          };
          # TODO make helper to create python dict from attrset
          tabs = {
            "padding[\"bottom\"]" = 4;
            "padding[\"top\"]" = 4;
            position = "top";
            max_width = 160;
          };
          statusbar = {
            "padding[\"bottom\"]" = 4;
            "padding[\"top\"]" = 4;
            position = "bottom";
          };
          content.javascript.clipboard = "access";
          zoom.default = "90%";
          scrolling.bar = "when-searching";
          hints.chars = "arstneiodh"; # colemak!
          content.blocking = {
            enabled = true;
            method = "both";
          };
        };
        keyBindings = with config.utils.keybinds; {
          # see :help bindings.default
          caret = {
            "${vi.left}" = "move-to-prev-char";
            "${vi.down}" = "move-to-next-line";
            "${vi.up}" = "move-to-prev-line";
            "${vi.right}" = "move-to-next-char";
          };
          normal = let
            rofi = "${pkgs.rofi}/bin/rofi -dmenu";
            spawn = ''
              spawn --userscript qute-pass -U secret -u "login: (.+)" -d "${rofi}"'';
          in {
            "${vi.left}" = "scroll left";
            "${vi.down}" = "scroll down";
            "${vi.up}" = "scroll up";
            "${vi.right}" = "scroll right";
            "${lib.toUpper vi.left}" = "tab-prev";
            "${lib.toUpper vi.up}" = "forward";
            "${lib.toUpper vi.down}" = "back";
            "${lib.toUpper vi.right}" = "tab-next";
            "${vi.jump-inclusive}" = "hint";
            "${vi.insert-before}" = "mode-enter insert";
            "${vi.insert-after}" = "mode-enter insert";
            "${vi.undo}" = "undo";
            "${vi.search-next}" = "search-next";
            "${lib.toUpper vi.search-next}" = "search-prev";
            "xs" = "config-cycle tabs.position top left";
            "zl" = "${spawn}";
            "zul" = "${spawn} --username-only";
            "zpl" = "${spawn} --password-only";
          };
        };
        extraConfig = let
          themeFile = pkgs.writeTextFile {
            name = "theme.py";
            text =
              config.utils.mustache.eval-base16
              (builtins.readFile base16-qutebrowser);
          };
        in ''
          config.source("${themeFile}")
          # load the selected tab foreground after the theme
          c.colors.tabs.even.bg = "#${config.colorscheme.palette.base01}";
          c.colors.tabs.odd.bg = "#${config.colorscheme.palette.base02}";
          c.colors.tabs.selected.even.bg = "#${config.colorscheme.palette.base0D}";
          c.colors.tabs.selected.odd.bg = "#${config.colorscheme.palette.base0D}";
          c.colors.tabs.selected.even.fg = "#${config.colorscheme.palette.base02}";
          c.colors.tabs.selected.odd.fg = "#${config.colorscheme.palette.base02}";
        '';
      };
    };
}

{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
# https://github.com/GnRlLeclerc/firefox-native-base16/tree/master?tab=readme-ov-file
# depends on Dynamic Base16 extension
{
  options = {
    modules.firefox = {
      enable =
        lib.mkEnableOption
        "whether or not to enable firefox (and theming support)";
      package = pkgs.firefox;
    };
  };
  config = let
    # download and fill in mustache template
    fnb-template = "${inputs.firefox-native-base16}/template.mustache";
    fnb-theme-file = pkgs.writeTextFile {
      name = "fnb-base16.toml";
      text =
        config.utils.mustache.eval-base16-with-palette
        (with inputs.nix-rice.lib.nix-rice;
          config.colorScheme.palette
          // {
            base00 =
              color.toRgbShortHex (color.darken 6
                (color.hexToRgba "#${config.colorscheme.palette.base00}"));
            base01 = config.colorscheme.palette.base00;
            base02 =
              color.toRgbShortHex (color.darken 6
                (color.hexToRgba "#${config.colorscheme.palette.base00}"));
          })
        (builtins.readFile fnb-template);
    };

    # build firefox-native-base16 binary and launcher
    fnb-binary = "${pkgs.firefox-native-base16}/bin/firefox-native-base16";
    fnb-launcher = pkgs.writeShellScript "firefox-native-base16-launcher" ''
      # Kill the binary when SIGTERM is received
      trap 'kill -SIGTERM $native_pid' SIGTERM

      # Run the binary in the background, storing its PID
      ${fnb-binary} --colors-path ${fnb-theme-file} &
      native_pid=$!
      wait $native_pid
    '';
  in
    lib.mkIf config.modules.firefox.enable {
      home.sessionVariables = lib.mkIf
        (config.modules.desktops.primary_display_server == "xorg") {
          # enable smooth scrolling on X11
          # TODO enable this, but not on wayland
          MOZ_USE_XINPUT2 = "1";
        };
      # actually enable firefox
      programs.firefox.enable = true;
      # write manifest to tell firefox where the launcher is
      home.file.".mozilla/native-messaging-hosts/firefox_native_base16.json".text = ''
        {
          "name": "firefox_native_base16",
          "description": "Native messaging application to dynamically communicate base16 colorschemes to Firefox",
          "type": "stdio",
          "path": "${fnb-launcher}",
          "allowed_extensions": ["dynamic_base16@gnrl_leclerc.org"]
        }
      '';
      # browserpass for password management
      programs.browserpass = {
        browsers = ["firefox"];
        enable = true;
      };
    };
}

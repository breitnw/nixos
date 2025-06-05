{
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
    };
  };
  config = let
    # download and fill in mustache template
    fnb-repo = fetchGit {
      url = "https://github.com/GnRlLeclerc/firefox-native-base16.git";
      rev = "6f2d7e4142975f10234bd43d6870c0e85d0650ac";
    };
    fnb-template = "${fnb-repo}/template.mustache";
    fnb-theme-file = pkgs.writeTextFile {
      name = "fnb-base16.toml";
      text = config.utils.mustache.eval-base16 (builtins.readFile fnb-template);
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

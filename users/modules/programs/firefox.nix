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

      # search engines
      programs.firefox.profiles.default.search = {
        force = true;
        default = "kagi";
        engines = {
          kagi = {
            name = "Kagi";
            urls = [{
              template = "https://kagi.com/search?";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
          };
          nix-packages = {
            name = "Nixpkgs";
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = [ "@pkgs" ];
          };
          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
            definedAliases = [ "@wiki" ];
          };
          nixos-options = {
            name = "NixOS Options";
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = [ "@opts" ];
          };
          home-manager-options = {
            name = "Home-Manager Options";
            urls = [{
              template = "https://home-manager-options.extranix.com";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = [ "@hm" ];
          };
        };
      };

      # policies and extensions
      # see: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
      programs.firefox.policies = let
        lock = val: {
          Value = val;
          Status = "locked";
        };
      in {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "newtab"; # alternatives: "never" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "separate"; # alternative: "unified"

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # LeechBlock NG
          "leechblockng@proginosko.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/leechblock-ng/latest.xpi";
            installation_mode = "force_installed";
          };
          # AdNauseam
          "adnauseam@rednoise.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
            installation_mode = "force_installed";
          };
          # BrowserPass
          "browserpass@maximbaz.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/browserpass-ce/latest.xpi";
            installation_mode = "force_installed";
          };
          # Dynamic Base16
          "dynamic_base16@gnrl_leclerc.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/dynamic-base16/latest.xpi";
            installation_mode = "force_installed";
          };
          # Kagi Search
          "search@kagi.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
            installation_mode = "force_installed";
          };
          # Old Twitter Layout
          "oldtwitter@dimden.dev-reupload" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/old-twitter-layout-2024/latest.xpi";
            installation_mode = "force_installed";
          };
          # Old Reddit Redirect
          "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/old-reddit-redirect/latest.xpi";
            installation_mode = "force_installed";
          };
        };
  
        /* ---- PREFERENCES ---- */
        # Check about:config for options.
        Preferences = { 
          # defaults
          "browser.contentblocking.category" = lock "strict";
          "extensions.pocket.enabled" = lock false;
          "extensions.screenshots.disabled" = lock true;
          "browser.topsites.contile.enabled" = lock false;
          "browser.formfill.enable" = lock false;
          "browser.search.suggest.enabled" = lock false;
          "browser.search.suggest.enabled.private" = lock false;
          "browser.urlbar.suggest.searches" = lock false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock false;
          "browser.newtabpage.activity-stream.showSponsored" = lock false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock false;

          # native window decorations
          "browser.tabs.inTitlebar" = lock 0; 

          # gestures
          "browser.gesture.swipe.left" = lock "";
          "browser.gesture.swipe.right" = lock "";
          "general.smoothScroll" = lock true;

          # disable ai slop
          "browser.ml.chat.enabled" = lock false;
          "browser.ml.enable" = lock false;
          "browser.ml.linkPreview.enabled" = lock false;
          "browser.ml.pageAssist.enabled" = lock false;
          "browser.ml.smartAssist.enabled" = lock false;
          "extensions.ml.enabled" = lock false;
          "browser.tabs.groups.smart.enabled" = lock false;
          "browser.search.visualSearch.featureGate" = lock false;
          "browser.urlbar.quicksuggest.mlEnabled" = lock false;
          "sidebar.revamp" = lock false;
          "browser.aiwindow.enabled" = lock false;
        };
      };
    };
}

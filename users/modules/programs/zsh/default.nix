{
  pkgs,
  ...
}: {
  # should this be here?
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # home.shell.enableBashIntegration = true;
  # home.shell.enableZshIntegration = true;

  # For some reason we need bash in order for firefox to pick up on the smooth
  # scrolling environment variable
  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    # initContent = lib.mkOrder 1500 ''
    #   if [[ $TERM == "alacritty" ]]; then
    #     fastfetch
    #   fi
    # '';
    autosuggestion.enable = true;
    autosuggestion.strategy = [
      "history"
      "completion"
    ];
    shellAliases = {
      open = "xdg-open";
    };
    oh-my-zsh = {
      enable = true;
      theme = "custom";
      plugins = [
        "git"
        "sudo"
        "extract"
        "colemak"
        "colored-man-pages"
      ];
      custom = "${./zsh_custom}";
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "1.9.0";
          sha256 = "sha256-+3iAmWXSsc4OhFZqAMTwOL7AAHBp5ZtGGtvqCnEOYc0=";
        };
      }
    ];
  };
}

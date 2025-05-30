{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    # autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "daveverwer";
      plugins = [
        "git"
        "sudo"
      ];
    };
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
    ];
  };
}

{...}: {
  programs.git = {
    enable = true;
    userEmail = "breitling.nw@gmail.com";
    userName = "Nick Breitling";
    ignores = [
      ".ccls-cache"
      ".direnv"
      ".envrc"
    ];
    extraConfig = {pull.rebase = false;};
    aliases = {
      adog = "git -c core.pager='less -S' log --all --decorate --oneline --graph";
    };
  };
}

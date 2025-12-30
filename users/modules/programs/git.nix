{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.email = "breitling.nw@gmail.com";
      user.name = "Nick Breitling";
      alias = {
        adog = "git -c core.pager='less -S' log --all --decorate --oneline --graph";
      };
      pull.rebase = false;
    };
    ignores = [
      ".ccls-cache"
      ".direnv"
      ".envrc"
    ];
  };
}

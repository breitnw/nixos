{...}: {
  programs.git = {
    enable = true;
    userEmail = "breitling.nw@gmail.com";
    userName = "Nick Breitling";
    extraConfig = {pull.rebase = false;};
    aliases = {
      adog = "git -c core.pager='less -S' log --all --decorate --oneline --graph";
    };
  };
}

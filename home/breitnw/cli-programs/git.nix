{ ... }:

{
  programs.git = {
    enable = true;
    userEmail = "breitling.nw@gmail.com";
    userName = "Nick Breitling";
    extraConfig = { pull.rebase = false; };
  };
}

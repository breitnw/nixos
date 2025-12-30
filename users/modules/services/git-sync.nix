{ pkgs, ... }:

{
  home.packages = [ pkgs.git-sync ];

  services.git-sync = {
    enable = true;
    repositories = {
      passwords = {
        interval = 500;
        path = /home/breitnw/.local/share/password-store;
        uri = "git+ssh://git@github.com:breitnw/passwords.git";
      };
      # notes = {
      #   interval = 500;
      #   path = /home/breitnw/Documents/org;
      #   uri = "git+ssh://git@github.com:breitnw/notes.git";
      # };
    };
  };
}

{...}: {
  imports = [
    ./options.nix
  ];
  config = {
    modules.mail.accounts = {
      "School" = {
        primary = true;
        gmail = true;
        mainAddress = "NicholasBreitling2027@u.northwestern.edu";
        makeMainAddressContext = false;
        aliases = ["breitnw@u.northwestern.edu"];
        realName = "Nick Breitling";
      };
      "Personal" = {
        primary = false;
        gmail = true;
        mainAddress = "breitling.nw@gmail.com";
        realName = "Nick Breitling";
      };
    };
  };
}

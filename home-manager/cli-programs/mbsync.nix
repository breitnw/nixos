{ ... }:

{
  # programs.mbsync = {
  #   enable = true;
  # };
  # automatically sync with services.mbsync
  # services.mbsync = {
  #   enable = true;
  #   frequency = "*:0/5";
  # };
  accounts.email = {
    maildirBasePath = "/home/breitnw/MailTest";

    accounts = {
      "Northwestern" = {
        address = "breitnw@u.northwestern.edu";
        passwordCommand = "pass email/breitnw@u.northwestern.edu";
        # userName automatically set
        # imap.host and imap.port automatically set
        # TODO: UID storage scheme?
        aliases = [ "NicholasBreitling2027@u.northwestern.edu" ];
        flavor = "gmail.com";
        mbsync = {
          enable = true;
          create = "both";  # sync mailbox creations
          # expunge = "both"; # sync message expunges (permanent deletion)
          remove = "both";  # sync mailbox deletions
          patterns = [
            "*" "![Gmail]/All Mail" "![Gmail]/Important" "![Gmail]/Starred" "![Gmail]/Bin"
          ];
        };
      };
    };
  };
}

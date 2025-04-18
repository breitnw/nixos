{ ... }:

{
  # TODO move these to the corresponding modules, generate from
  # corresponding config
  sops.secrets = {
    # mail accounts
    "accounts/email/NicholasBreitling2027@u.northwestern.edu" = { };
    "accounts/email/breitling.nw@gmail.com" = { };
    # webdav syncing
    "accounts/webdav/breitnw" = { };
    # calendar
    "accounts/caldav/breitnw" = { };
  };
}
